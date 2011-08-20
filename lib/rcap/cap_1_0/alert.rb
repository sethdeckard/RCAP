module RCAP
  module CAP_1_0
    # An Alert object is valid if
    # * it has an identifier
    # * it has a sender
    # * it has a sent time
    # * it has a valid status value
    # * it has a valid messge type value
    # * it has a valid scope value
    # * all Info objects contained in infos are valid
    class Alert
      include Validation

      XMLNS = "http://www.incident.com/cap/1.0"
      CAP_VERSION = "1.0"

      STATUS_ACTUAL   = "Actual"   
      STATUS_EXERCISE = "Exercise" 
      STATUS_SYSTEM   = "System"   
      STATUS_TEST     = "Test"     
      # Valid values for status
      VALID_STATUSES = [ STATUS_ACTUAL, STATUS_EXERCISE, STATUS_SYSTEM, STATUS_TEST ]

      MSG_TYPE_ALERT  = "Alert"   
      MSG_TYPE_UPDATE = "Update"  
      MSG_TYPE_CANCEL = "Cancel"  
      MSG_TYPE_ACK    = "Ack"     
      MSG_TYPE_ERROR  = "Error"   
      # Valid values for msg_type
      VALID_MSG_TYPES = [ MSG_TYPE_ALERT, MSG_TYPE_UPDATE, MSG_TYPE_CANCEL, MSG_TYPE_ACK, MSG_TYPE_ERROR ]

      SCOPE_PUBLIC     = "Public"        
      SCOPE_RESTRICTED = "Restricted"    
      SCOPE_PRIVATE    = "Private"       
      # Valid values for scope
      VALID_SCOPES = [ SCOPE_PUBLIC, SCOPE_PRIVATE, SCOPE_RESTRICTED ]


      # If not set a UUID will be set by default
      attr_accessor( :identifier)
      attr_accessor( :sender )
      # Sent Time - If not set will value will be time of creation.
      attr_accessor( :sent )
      # Value can only be one of VALID_STATUSES
      attr_accessor( :status )
      # Value can only be one of VALID_MSG_TYPES
      attr_accessor( :msg_type )
      attr_accessor( :password )
      # Value can only be one of VALID_SCOPES
      attr_accessor( :scope )
      attr_accessor( :source )
      # Depends on scope being SCOPE_RESTRICTED.
      attr_accessor( :restriction )
      attr_accessor( :note )

      # Collection of address strings. Depends on scope being SCOPE_PRIVATE.
      attr_reader( :addresses )
      attr_reader( :codes )
      # Collection of reference strings - see Alert#to_reference
      attr_reader( :references)
      # Collection of incident strings
      attr_reader( :incidents )
      # Collection of Info objects
      attr_reader( :infos )

      validates_presence_of( :identifier, :sender, :sent, :status, :msg_type, :scope )

      validates_inclusion_of( :status,   :in => VALID_STATUSES )
      validates_inclusion_of( :msg_type, :in => VALID_MSG_TYPES )
      validates_inclusion_of( :scope,    :in => VALID_SCOPES )

      validates_format_of( :identifier, :with => ALLOWED_CHARACTERS )
      validates_format_of( :sender ,    :with => ALLOWED_CHARACTERS )

      validates_dependency_of( :addresses,   :on => :scope, :with_value => SCOPE_PRIVATE )
      validates_dependency_of( :restriction, :on => :scope, :with_value => SCOPE_RESTRICTED )

      validates_collection_of( :infos )

      def initialize( attributes = {})
        @identifier  = attributes[ :identifier ] || RCAP.generate_identifier
        @sender      = attributes[ :sender ]
        @sent        = attributes[ :sent ]
        @status      = attributes[ :status ]
        @msg_type    = attributes[ :msg_type ]
        @password    = attributes[ :password ]
        @scope       = attributes[ :scope ]
        @source      = attributes[ :source ]
        @restriction = attributes[ :restriction ]
        @addresses   = Array( attributes[ :addresses ])
        @codes       = Array( attributes[ :codes ])
        @references  = Array( attributes[ :references ])
        @incidents   = Array( attributes[ :incidents ])
        @infos       = Array( attributes[ :infos ])
      end

      # Creates a new Info object and adds it to the infos array. The
      # info_attributes are passed as a parameter to Info.new.
      def add_info( info_attributes  = {})
        info = Info.new( info_attributes )
        @infos << info
        info
      end

      XML_ELEMENT_NAME         = 'alert'       
      IDENTIFIER_ELEMENT_NAME  = 'identifier'  
      SENDER_ELEMENT_NAME      = 'sender'      
      SENT_ELEMENT_NAME        = 'sent'        
      STATUS_ELEMENT_NAME      = 'status'      
      MSG_TYPE_ELEMENT_NAME    = 'msgType'     
      PASSWORD_ELEMENT_NAME    = 'password'    
      SOURCE_ELEMENT_NAME      = 'source'      
      SCOPE_ELEMENT_NAME       = 'scope'       
      RESTRICTION_ELEMENT_NAME = 'restriction' 
      ADDRESSES_ELEMENT_NAME   = 'addresses'   
      CODE_ELEMENT_NAME        = 'code'        
      NOTE_ELEMENT_NAME        = 'note'        
      REFERENCES_ELEMENT_NAME  = 'references'  
      INCIDENTS_ELEMENT_NAME   = 'incidents'   

      def to_xml_element 
        xml_element = REXML::Element.new( XML_ELEMENT_NAME )
        xml_element.add_namespace( XMLNS )
        xml_element.add_element( IDENTIFIER_ELEMENT_NAME ).add_text( @identifier )   if @identifier
        xml_element.add_element( SENDER_ELEMENT_NAME ).add_text( @sender )           if @sender
        xml_element.add_element( SENT_ELEMENT_NAME ).add_text( @sent.to_s_for_cap )  if @sent
        xml_element.add_element( STATUS_ELEMENT_NAME ).add_text( @status )           if @status
        xml_element.add_element( MSG_TYPE_ELEMENT_NAME ).add_text( @msg_type )       if @msg_type
        xml_element.add_element( PASSWORD_ELEMENT_NAME ).add_text( @password )       if @password
        xml_element.add_element( SOURCE_ELEMENT_NAME ).add_text( @source )           if @source
        xml_element.add_element( SCOPE_ELEMENT_NAME ).add_text( @scope )             if @scope
        xml_element.add_element( RESTRICTION_ELEMENT_NAME ).add_text( @restriction ) if @restriction
        unless @addresses.empty?
          xml_element.add_element( ADDRESSES_ELEMENT_NAME ).add_text( @addresses.to_s_for_cap )
        end
        @codes.each do |code|
          xml_element.add_element( CODE_ELEMENT_NAME ).add_text( code )
        end
        xml_element.add_element( NOTE_ELEMENT_NAME ).add_text( @note ) if @note
        unless @references.empty?
          xml_element.add_element( REFERENCES_ELEMENT_NAME ).add_text( @references.join( ' ' ))
        end
        unless @incidents.empty?
          xml_element.add_element( INCIDENTS_ELEMENT_NAME ).add_text( @incidents.join( ' ' ))
        end
        @infos.each do |info|
          xml_element.add_element( info.to_xml_element )
        end
        xml_element
      end

      def to_xml_document 
        xml_document = REXML::Document.new
        xml_document.add( REXML::XMLDecl.new )
        xml_document.add( to_xml_element )
        xml_document
      end

      # Returns a string containing the XML representation of the alert.
      def to_xml( pretty_print = false )
        if pretty_print
          xml_document = ""
          XML_PRETTY_PRINTER.write( to_xml_document, xml_document )
          xml_document
        else
          to_xml_document.to_s
        end
      end

      # Returns a string representation of the alert suitable for usage as a reference in a CAP message of the form
      #  sender,identifier,sent
      def to_reference
        "#{ @sender },#{ @identifier },#{ @sent }"
      end

      def inspect 
        alert_inspect = [ "CAP Version:  #{ CAP_VERSION }",
                          "Identifier:   #{ @identifier }",
                          "Sender:       #{ @sender }",
                          "Sent:         #{ @sent }",
                          "Status:       #{ @status }",
                          "Message Type: #{ @msg_type }",
                          "Password:     #{ @password }",
                          "Source:       #{ @source }",
                          "Scope:        #{ @scope }",
                          "Restriction:  #{ @restriction }",
                          "Addresses:    #{ @addresses.to_s_for_cap }",
                          "Codes:",
                          @codes.map{ |code| "  " + code }.join("\n")+"",
                          "Note:         #{ @note }",
                          "References:   #{ @references.join( ' ' )}",
                          "Incidents:    #{ @incidents.join( ' ')}",
                          "Information:",
                          @infos.map{ |info| "  " + info.to_s }.join( "\n" )].join("\n")
        RCAP.format_lines_for_inspect( 'ALERT', alert_inspect )
      end

      # Returns a string representation of the alert of the form
      #  sender/identifier/sent
      # See Alert#to_reference for another string representation suitable as a CAP reference.
      def to_s
        "#{ @sender }/#{ @identifier }/#{ @sent }"
      end

      XPATH             = 'cap:alert'                         
      IDENTIFIER_XPATH  = "cap:#{ IDENTIFIER_ELEMENT_NAME }"  
      SENDER_XPATH      = "cap:#{ SENDER_ELEMENT_NAME }"      
      SENT_XPATH        = "cap:#{ SENT_ELEMENT_NAME }"        
      STATUS_XPATH      = "cap:#{ STATUS_ELEMENT_NAME }"      
      MSG_TYPE_XPATH    = "cap:#{ MSG_TYPE_ELEMENT_NAME }"    
      PASSWORD_XPATH    = "cap:#{ PASSWORD_ELEMENT_NAME }"    
      SOURCE_XPATH      = "cap:#{ SOURCE_ELEMENT_NAME }"      
      SCOPE_XPATH       = "cap:#{ SCOPE_ELEMENT_NAME }"       
      RESTRICTION_XPATH = "cap:#{ RESTRICTION_ELEMENT_NAME }" 
      ADDRESSES_XPATH   = "cap:#{ ADDRESSES_ELEMENT_NAME }"   
      CODE_XPATH        = "cap:#{ CODE_ELEMENT_NAME }"        
      NOTE_XPATH        = "cap:#{ NOTE_ELEMENT_NAME }"        
      REFERENCES_XPATH  = "cap:#{ REFERENCES_ELEMENT_NAME }"  
      INCIDENTS_XPATH   = "cap:#{ INCIDENTS_ELEMENT_NAME }"   

      def self.from_xml_element( alert_xml_element ) 
        self.new( :identifier  => RCAP.xpath_text( alert_xml_element, IDENTIFIER_XPATH, Alert::XMLNS ),
                  :sender      => RCAP.xpath_text( alert_xml_element, SENDER_XPATH, Alert::XMLNS ),
                  :sent        => (( sent = RCAP.xpath_first( alert_xml_element, SENT_XPATH, Alert::XMLNS )) ? DateTime.parse( sent.text ) : nil ),
                  :status      => RCAP.xpath_text( alert_xml_element, STATUS_XPATH, Alert::XMLNS ),
                  :msg_type    => RCAP.xpath_text( alert_xml_element, MSG_TYPE_XPATH, Alert::XMLNS ),
                  :password    => RCAP.xpath_text( alert_xml_element, PASSWORD_XPATH, Alert::XMLNS ),
                  :source      => RCAP.xpath_text( alert_xml_element, SOURCE_XPATH, Alert::XMLNS ),
                  :scope       => RCAP.xpath_text( alert_xml_element, SCOPE_XPATH, Alert::XMLNS ),
                  :restriction => RCAP.xpath_text( alert_xml_element, RESTRICTION_XPATH, Alert::XMLNS ),
                  :addresses   => (( address = RCAP.xpath_text( alert_xml_element, ADDRESSES_XPATH, Alert::XMLNS )) ? address.unpack_cap_list : nil ),
                  :codes       => RCAP.xpath_match( alert_xml_element, CODE_XPATH, Alert::XMLNS ).map{ |element| element.text },
                  :note        => RCAP.xpath_text( alert_xml_element, NOTE_XPATH, Alert::XMLNS ),
                  :references  => (( references = RCAP.xpath_text( alert_xml_element, REFERENCES_XPATH, Alert::XMLNS )) ? references.split( ' ' ) : nil ),
                  :incidents   => (( incidents = RCAP.xpath_text( alert_xml_element, INCIDENTS_XPATH, Alert::XMLNS )) ? incidents.split( ' ' ) : nil ),
                  :infos       => RCAP.xpath_match( alert_xml_element, Info::XPATH, Alert::XMLNS ).map{ |element| Info.from_xml_element( element )})
      end

      def self.from_xml_document( xml_document ) 
        self.from_xml_element( xml_document.root )
      end

      # Initialise an Alert object from an XML string. Any object that is a subclass of IO (e.g. File) can be passed in.
      def self.from_xml( xml )
        self.from_xml_document( REXML::Document.new( xml ))
      end

      CAP_VERSION_YAML = "CAP Version"        
      IDENTIFIER_YAML  = "Identifier"         
      SENDER_YAML      = "Sender"             
      SENT_YAML        = "Sent"               
      STATUS_YAML      = "Status"             
      MSG_TYPE_YAML    = "Message Type"       
      PASSWORD_YAML    = "Password"           
      SOURCE_YAML      = "Source"             
      SCOPE_YAML       = "Scope"              
      RESTRICTION_YAML = "Restriction"        
      ADDRESSES_YAML   = "Addresses"          
      CODES_YAML       = "Codes"              
      NOTE_YAML        = "Note"               
      REFERENCES_YAML  = "References"         
      INCIDENTS_YAML   = "Incidents"          
      INFOS_YAML       = "Information"        

      # Returns a string containing the YAML representation of the alert.
      def to_yaml( options = {} )
        RCAP.attribute_values_to_hash(
          [ CAP_VERSION_YAML, CAP_VERSION ],
          [ IDENTIFIER_YAML,  @identifier ],
          [ SENDER_YAML,      @sender ],
          [ SENT_YAML,        @sent ],
          [ STATUS_YAML,      @status ],
          [ MSG_TYPE_YAML,    @msg_type ],
          [ PASSWORD_YAML,    @password ],
          [ SOURCE_YAML,      @source ],
          [ SCOPE_YAML,       @scope ],
          [ RESTRICTION_YAML, @restriction ],
          [ ADDRESSES_YAML,   @addresses ],
          [ CODES_YAML,       @codes ],
          [ NOTE_YAML,        @note ],
          [ REFERENCES_YAML,  @references ],
          [ INCIDENTS_YAML,   @incidents ],
          [ INFOS_YAML,       @infos ]
        ).to_yaml( options )
      end

      # Initialise an Alert object from a YAML string. Any object that is a subclass of IO (e.g. File) can be passed in.
      def self.from_yaml( yaml )
        self.from_yaml_data( YAML.load( yaml ))
      end

      def self.from_yaml_data( alert_yaml_data ) 
        Alert.new(
          :identifier  => alert_yaml_data[ IDENTIFIER_YAML ],
          :sender      => alert_yaml_data[ SENDER_YAML ],
          :sent        => ( sent = alert_yaml_data[ SENT_YAML ]).blank? ? nil : DateTime.parse( sent.to_s ),
          :status      => alert_yaml_data[ STATUS_YAML ],
          :msg_type    => alert_yaml_data[ MSG_TYPE_YAML ],
          :password    => alert_yaml_data[ PASSWORD_YAML ],
          :source      => alert_yaml_data[ SOURCE_YAML ],
          :scope       => alert_yaml_data[ SCOPE_YAML ],
          :restriction => alert_yaml_data[ RESTRICTION_YAML ],
          :addresses   => alert_yaml_data[ ADDRESSES_YAML ],
          :codes       => alert_yaml_data[ CODES_YAML ],
          :note        => alert_yaml_data[ NOTE_YAML ],
          :references  => alert_yaml_data[ REFERENCES_YAML ],
          :incidents   => alert_yaml_data[ INCIDENTS_YAML ],
          :infos       => Array( alert_yaml_data[ INFOS_YAML ]).map{ |info_yaml_data| Info.from_yaml_data( info_yaml_data )}
        )
      end

      CAP_VERSION_KEY = 'cap_version' 
      IDENTIFIER_KEY  = 'identifier'  
      SENDER_KEY      = 'sender'      
      SENT_KEY        = 'sent'        
      STATUS_KEY      = 'status'      
      MSG_TYPE_KEY    = 'msg_type'    
      PASSWORD_KEY    = 'password'    
      SOURCE_KEY      = 'source'      
      SCOPE_KEY       = 'scope'       
      RESTRICTION_KEY = 'restriction' 
      ADDRESSES_KEY   = 'addresses'   
      CODES_KEY       = 'codes'       
      NOTE_KEY        = 'note'        
      REFERENCES_KEY  = 'references'  
      INCIDENTS_KEY   = 'incidents'   
      INFOS_KEY       = 'infos'       

      # Returns a Hash representation of an Alert object
      def to_h
        RCAP.attribute_values_to_hash( [ CAP_VERSION_KEY, CAP_VERSION ],
                                      [ IDENTIFIER_KEY,   @identifier ],
                                      [ SENDER_KEY,       @sender ],
                                      [ SENT_KEY,         RCAP.to_s_for_cap( @sent )],
                                      [ STATUS_KEY,       @status ],
                                      [ MSG_TYPE_KEY,     @msg_type ],
                                      [ PASSWORD_KEY,     @password ],
                                      [ SOURCE_KEY,       @source ],
                                      [ SCOPE_KEY,        @scope ],
                                      [ RESTRICTION_KEY,  @restriction ],
                                      [ ADDRESSES_KEY,    @addresses ],
                                      [ CODES_KEY,        @codes ],
                                      [ NOTE_KEY,         @note ],
                                      [ REFERENCES_KEY,   @references ],
                                      [ INCIDENTS_KEY,    @incidents ],
                                      [ INFOS_KEY,        @infos.map{ |info| info.to_h  }])
      end

      # Initialises an Alert object from a Hash produced by Alert#to_h
      def self.from_h( alert_hash )
        self.new(
          :identifier  => alert_hash[ IDENTIFIER_KEY ],
          :sender      => alert_hash[ SENDER_KEY ],
          :sent        => RCAP.parse_datetime( alert_hash[ SENT_KEY ]),
          :status      => alert_hash[ STATUS_KEY ],
          :msg_type    => alert_hash[ MSG_TYPE_KEY ],
          :password    => alert_hash[ PASSWORD_KEY ],
          :source      => alert_hash[ SOURCE_KEY ],
          :scope       => alert_hash[ SCOPE_KEY ],
          :restriction => alert_hash[ RESTRICTION_KEY ],
          :addresses   => alert_hash[ ADDRESSES_KEY ],
          :codes       => alert_hash[ CODES_KEY ],
          :note        => alert_hash[ NOTE_KEY ],
          :references  => alert_hash[ REFERENCES_KEY ],
          :incidents   => alert_hash[ INCIDENTS_KEY ],
          :infos       => Array( alert_hash[ INFOS_KEY ]).map{ |info_hash| Info.from_h( info_hash )})
      end

      # Returns a JSON string representation of an Alert object
      def to_json( pretty_print = false )
        if pretty_print
          JSON.pretty_generate( self.to_h )
        else
          self.to_h.to_json
        end
      end

      # Initiialises an Alert object from a JSON string produced by Alert#to_json
      def self.from_json( json_string )
        self.from_h( JSON.parse( json_string ))
      end
    end
  end
end
