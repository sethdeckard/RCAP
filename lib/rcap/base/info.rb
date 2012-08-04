module RCAP
  module Base
    class Info
      include Validation

      CATEGORY_GEO       = "Geo"       
      CATEGORY_MET       = "Met"       
      CATEGORY_SAFETY    = "Safety"    
      CATEGORY_SECURITY  = "Security"  
      CATEGORY_RESCUE    = "Rescue"    
      CATEGORY_FIRE      = "Fire"      
      CATEGORY_HEALTH    = "Health"    
      CATEGORY_ENV       = "Env"       
      CATEGORY_TRANSPORT = "Transport" 
      CATEGORY_INFRA     = "Infra"     
      CATEGORY_CBRNE     = "CBRNE"     
      CATEGORY_OTHER     = "Other"     
      # Valid values for categories
      VALID_CATEGORIES = [ CATEGORY_GEO, CATEGORY_MET, CATEGORY_SAFETY,
        CATEGORY_SECURITY, CATEGORY_RESCUE,   CATEGORY_FIRE, CATEGORY_HEALTH,
        CATEGORY_ENV, CATEGORY_TRANSPORT, CATEGORY_INFRA, CATEGORY_CBRNE,
        CATEGORY_OTHER ]

      URGENCY_IMMEDIATE = "Immediate" 
      URGENCY_EXPECTED  = "Expected"  
      URGENCY_FUTURE    = "Future"    
      URGENCY_PAST      = "Past"      
      URGENCY_UNKNOWN   = "Unknown"   
      # Valid values for urgency
      VALID_URGENCIES = [ URGENCY_IMMEDIATE, URGENCY_EXPECTED, URGENCY_FUTURE,
        URGENCY_PAST, URGENCY_UNKNOWN ]

      SEVERITY_EXTREME  = "Extreme"  
      SEVERITY_SEVERE   = "Severe"   
      SEVERITY_MODERATE = "Moderate" 
      SEVERITY_MINOR    = "Minor"    
      SEVERITY_UNKNOWN  = "Unknown"  
      # Valid values for severity
      VALID_SEVERITIES = [ SEVERITY_EXTREME, SEVERITY_SEVERE, SEVERITY_MODERATE,
        SEVERITY_MINOR, SEVERITY_UNKNOWN ]

      CERTAINTY_VERY_LIKELY = "Very Likely" 
      CERTAINTY_LIKELY      = "Likely"      
      CERTAINTY_POSSIBLE    = "Possible"    
      CERTAINTY_UNLIKELY    = "Unlikely"    
      CERTAINTY_UNKNOWN     = "Unknown"     
      # Valid valies for certainty
      VALID_CERTAINTIES = [ CERTAINTY_VERY_LIKELY, CERTAINTY_LIKELY,
        CERTAINTY_POSSIBLE, CERTAINTY_UNLIKELY, CERTAINTY_UNKNOWN ]

      XML_ELEMENT_NAME           = 'info'         
      LANGUAGE_ELEMENT_NAME      = 'language'     
      CATEGORY_ELEMENT_NAME      = 'category'     
      EVENT_ELEMENT_NAME         = 'event'        
      URGENCY_ELEMENT_NAME       = 'urgency'      
      SEVERITY_ELEMENT_NAME      = 'severity'     
      CERTAINTY_ELEMENT_NAME     = 'certainty'    
      AUDIENCE_ELEMENT_NAME      = 'audience'     
      EVENT_CODE_ELEMENT_NAME    = 'eventCode'    
      EFFECTIVE_ELEMENT_NAME     = 'effective'    
      ONSET_ELEMENT_NAME         = 'onset'        
      EXPIRES_ELEMENT_NAME       = 'expires'      
      SENDER_NAME_ELEMENT_NAME   = 'senderName'   
      HEADLINE_ELEMENT_NAME      = 'headline'     
      DESCRIPTION_ELEMENT_NAME   = 'description'  
      INSTRUCTION_ELEMENT_NAME   = 'instruction'  
      WEB_ELEMENT_NAME           = 'web'          
      CONTACT_ELEMENT_NAME       = 'contact'      

      XPATH               = "cap:#{ XML_ELEMENT_NAME }"           
      LANGUAGE_XPATH      = "cap:#{ LANGUAGE_ELEMENT_NAME }"      
      EVENT_XPATH         = "cap:#{ EVENT_ELEMENT_NAME }"         
      URGENCY_XPATH       = "cap:#{ URGENCY_ELEMENT_NAME }"       
      CATEGORY_XPATH      = "cap:#{ CATEGORY_ELEMENT_NAME }"      
      SEVERITY_XPATH      = "cap:#{ SEVERITY_ELEMENT_NAME }"      
      CERTAINTY_XPATH     = "cap:#{ CERTAINTY_ELEMENT_NAME }"     
      AUDIENCE_XPATH      = "cap:#{ AUDIENCE_ELEMENT_NAME }"      
      EVENT_CODE_XPATH    = "cap:#{ EVENT_CODE_ELEMENT_NAME }"    
      EFFECTIVE_XPATH     = "cap:#{ EFFECTIVE_ELEMENT_NAME }"     
      ONSET_XPATH         = "cap:#{ ONSET_ELEMENT_NAME }"         
      EXPIRES_XPATH       = "cap:#{ EXPIRES_ELEMENT_NAME }"       
      SENDER_NAME_XPATH   = "cap:#{ SENDER_NAME_ELEMENT_NAME }"   
      HEADLINE_XPATH      = "cap:#{ HEADLINE_ELEMENT_NAME }"      
      DESCRIPTION_XPATH   = "cap:#{ DESCRIPTION_ELEMENT_NAME }"   
      INSTRUCTION_XPATH   = "cap:#{ INSTRUCTION_ELEMENT_NAME }"   
      WEB_XPATH           = "cap:#{ WEB_ELEMENT_NAME }"           
      CONTACT_XPATH       = "cap:#{ CONTACT_ELEMENT_NAME }"       

      DEFAULT_LANGUAGE = 'en-US'

      validates_presence_of( :event )
      validates_presence_of( :urgency )
      validates_presence_of( :severity )
      validates_presence_of( :certainty )
      validates_inclusion_of( :severity, :allow_nil  => true, :in => VALID_SEVERITIES,  :message => "can only be assigned the following values: #{ VALID_SEVERITIES.join(', ') }" )
      validates_inclusion_of( :urgency, :allow_nil   => true, :in => VALID_URGENCIES,   :message => "can only be assigned the following values: #{ VALID_URGENCIES.join(', ') }" )
      validates_inclusion_of_members_of( :categories, :in  => VALID_CATEGORIES, :allow_blank => true )
      validates_collection_of( :resources, :areas, :event_codes, :parameters )

      # @return [String]
      attr_accessor( :event )
      # @return [String] Value can only be one of {VALID_URGENCIES} 
      attr_accessor( :urgency )
      # @return [String] Value can only be one of {VALID_SEVERITIES} 
      attr_accessor( :severity )
      # @return [String] Value can only be one of {VALID_CERTAINTIES} 
      attr_accessor( :certainty )
      # @return [String]
      attr_accessor( :language )
      # @return [String]
      attr_accessor( :audience )
      # @return [DateTime] Effective start time of information 
      attr_accessor( :effective )
      # @return [DateTime] Expected start of event 
      attr_accessor( :onset )
      # @return [DateTime] Effective expiry time of information 
      attr_accessor( :expires )
      # @return [String]
      attr_accessor( :sender_name )
      # @return [String]
      attr_accessor( :headline )
      # @return [String]
      attr_accessor( :description )
      # @return [String]
      attr_accessor( :instruction )
      # @return [String]
      attr_accessor( :web )
      # @return [String]
      attr_accessor( :contact )

      # @return [Array<String>] Collection of textual categories; elements can be one of {VALID_CATEGORIES} 
      attr_reader( :categories )
      # @return [Array<EventCode>] Collection of {EventCode} objects
      attr_reader( :event_codes )
      # @return [Array<Parameter>] Collection of {Parameter} objects
      attr_reader( :parameters )
      # @return [Array<Resource> Collection of {Resource} objects
      attr_reader( :resources )
      # @return [Array<Area>] Collection of {Area} objects
      attr_reader( :areas )

      # @param [Hash] attributes
      # @option attributes [String] :language Defaults to {DEFAULT_LANGUAGE}
      # @option attributes [Array<String>] :categories Collection of categories in {VALID_CATEGORIES}
      # @option attributes [String] :audience
      # @option attributes [String] :event
      # @option attributes [String] :urgency A member of {VALID_URGENCIES}
      # @option attributes [String] :severity A member of {VALID_SEVERITIES}
      # @option attributes [String] :certainty A member of {VALID_CERTAINTIES}
      # @option attributes [DateTime] :effective 
      # @option attributes [DateTime] :onset
      # @option attributes [DateTime] :expires
      # @option attributes [Array<EventCode>] :event_codes Collection of {EventCode} objects
      # @option attributes [String] :sender_name
      # @option attributes [String] :headline
      # @option attributes [String] :description
      # @option attributes [String] :instruction
      # @option attributes [String] :web URL
      # @option attributes [String] :contact
      # @option attributes [Array<Parameter>] :parameters Collection of {Parameter} objects
      # @option attributes [Array<Resource>] :resources Collection of {Resource} objects 
      # @option attributes [Array<Area>] :areas Collection of {Area} objects
      def initialize( attributes = {} )
        @language       = attributes[ :language ] || DEFAULT_LANGUAGE
        @categories     = attributes[ :categories ] || []
        @audience       = attributes[ :audience ]
        @event          = attributes[ :event ]
        @urgency        = attributes[ :urgency ]
        @severity       = attributes[ :severity ]
        @certainty      = attributes[ :certainty ]
        @effective      = attributes[ :effective ]
        @onset          = attributes[ :onset ]
        @expires        = attributes[ :expires ]
        @event_codes    = attributes[ :event_codes ] || []
        @sender_name    = attributes[ :sender_name ]
        @headline       = attributes[ :headline ]
        @description    = attributes[ :description ]
        @instruction    = attributes[ :instruction ]
        @web            = attributes[ :web ]
        @contact        = attributes[ :contact ]
        @parameters     = attributes[ :parameters ] || []
        @resources      = attributes[ :resources ] || []
        @areas          = attributes[ :areas ] || []
      end

      # Creates a new EventCode object and adds it to the event_codes array. The
      # event_code_attributes are passed as a parameter to EventCode.new.
      #
      # @see EventCode#initialize
      #
      # @return [EventCode]
      def add_event_code
        event_code = self.event_code_class.new
        yield( event_code ) if block_given?
        @event_codes << event_code
        event_code
      end

      # Creates a new Parameter object and adds it to the parameters array. The
      # parameter_attributes are passed as a parameter to Parameter.new.
      #
      # @see Parameter#initialize
      #
      # @return [Parameter]
      def add_parameter
        parameter = self.parameter_class.new
        yield( parameter ) if block_given?
        @parameters << parameter
        parameter
      end

      # Creates a new Resource object and adds it to the resources array. The
      # resource_attributes are passed as a parameter to Resource.new.
      #
      # @see Resource#initialize
      #
      # @return [Resource]
      def add_resource( resource_attributes = {})
        resource = self.resource_class.new
        yield( resource ) if block_given?
        @resources << resource
        resource
      end

      # Creates a new Area object and adds it to the areas array. The
      # area_attributes are passed as a parameter to Area.new.
      #
      # @see Area#initialize
      #
      # @return [Area]
      def add_area
        area = Area.new( area_attributes )
        @areas << area
        area
      end

      # @return [REXML::Element]
      def to_xml_element 
        xml_element = REXML::Element.new( XML_ELEMENT_NAME )
        xml_element.add_element( LANGUAGE_ELEMENT_NAME ).add_text( @language ) if @language
        @categories.each do |category|
          xml_element.add_element( CATEGORY_ELEMENT_NAME ).add_text( category )
        end
        xml_element.add_element( EVENT_ELEMENT_NAME ).add_text( @event )
        xml_element.add_element( URGENCY_ELEMENT_NAME ).add_text( @urgency )
        xml_element.add_element( SEVERITY_ELEMENT_NAME ).add_text( @severity )
        xml_element.add_element( CERTAINTY_ELEMENT_NAME ).add_text( @certainty )
        xml_element.add_element( AUDIENCE_ELEMENT_NAME ).add_text( @audience ) if @audience
        @event_codes.each do |event_code|
          xml_element.add_element( event_code.to_xml_element )
        end
        xml_element.add_element( EFFECTIVE_ELEMENT_NAME ).add_text( @effective.to_s_for_cap ) if @effective
        xml_element.add_element( ONSET_ELEMENT_NAME ).add_text( @onset.to_s_for_cap )         if @onset
        xml_element.add_element( EXPIRES_ELEMENT_NAME ).add_text( @expires.to_s_for_cap )     if @expires
        xml_element.add_element( SENDER_NAME_ELEMENT_NAME ).add_text( @sender_name )          if @sender_name
        xml_element.add_element( HEADLINE_ELEMENT_NAME ).add_text( @headline )                if @headline
        xml_element.add_element( DESCRIPTION_ELEMENT_NAME ).add_text( @description )          if @description
        xml_element.add_element( INSTRUCTION_ELEMENT_NAME ).add_text( @instruction )          if @instruction
        xml_element.add_element( WEB_ELEMENT_NAME ).add_text( @web )                          if @web
        xml_element.add_element( CONTACT_ELEMENT_NAME ).add_text( @contact )                  if @contact
        @parameters.each do |parameter|
          xml_element.add_element( parameter.to_xml_element )
        end
        @resources.each do |resource|
          xml_element.add_element( resource.to_xml_element )
        end
        @areas.each do |area|
          xml_element.add_element( area.to_xml_element )
        end
        xml_element
      end

      # @return [String]
      def to_xml 
        self.to_xml_element.to_s
      end

      # @return [String]
      def inspect 
        info_inspect = "Language:       #{ @language }\n"+
        "Categories:     #{ @categories.to_s_for_cap }\n"+
        "Event:          #{ @event }\n"+
        "Urgency:        #{ @urgency }\n"+
        "Severity:       #{ @severity }\n"+
        "Certainty:      #{ @certainty }\n"+
        "Audience:       #{ @audience }\n"+
        "Event Codes:    #{ @event_codes.inspect }\n"+
        "Effective:      #{ @effective }\n"+
        "Onset:          #{ @onset }\n"+
        "Expires:        #{ @expires }\n"+
        "Sender Name:    #{ @sender_name }\n"+
        "Headline:       #{ @headline }\n"+
        "Description:\n"+
          @description.to_s.lines.map{ |line| "  " + line }.join( "\n")+"\n"+
          "Instruction:    #{ @instruction }\n"+
        "Web:            #{ @web }\n"+
        "Contact:        #{ @contact }\n"+
        "Parameters:\n"+
          @parameters.map{ |parameter| "  " + parameter.inspect }.join( "\n" )+"\n"+
          "Resources:\n"+
          @resources.map{ |resource| "  " + resource.inspect }.join( "\n" )+"\n"+
          "Area:\n"+
          @areas.map{ |area| "  #{ area }" }.join( "\n" )+"\n"
        RCAP.format_lines_for_inspect( 'INFO', info_inspect )
      end

      # Returns a string representation of the event of the form
      #  event(urgency/severity/certainty)
      #
      # @return [String]
      def to_s
        "#{ @event }(#{ @urgency }/#{ @severity }/#{ @certainty })"
      end

      LANGUAGE_YAML       = 'Language'       
      CATEGORIES_YAML     = 'Categories'     
      EVENT_YAML          = 'Event'          
      URGENCY_YAML        = 'Urgency'        
      SEVERITY_YAML       = 'Severity'       
      CERTAINTY_YAML      = 'Certainty'      
      AUDIENCE_YAML       = 'Audience'       
      EFFECTIVE_YAML      = 'Effective'      
      ONSET_YAML          = 'Onset'          
      EXPIRES_YAML        = 'Expires'        
      SENDER_NAME_YAML    = 'Sender Name'    
      HEADLINE_YAML       = 'Headline'       
      DESCRIPTION_YAML    = 'Description'    
      INSTRUCTION_YAML    = 'Instruction'    
      WEB_YAML            = 'Web'            
      CONTACT_YAML        = 'Contact'        
      EVENT_CODES_YAML    = 'Event Codes'    
      PARAMETERS_YAML     = 'Parameters'     
      RESOURCES_YAML      = 'Resources'      
      AREAS_YAML          = 'Areas'          

      # @return [String]
      def to_yaml( options = {} ) 
        parameter_to_hash = lambda{ |hash, parameter| hash.merge( parameter.name => parameter.value )}

        RCAP.attribute_values_to_hash( [ LANGUAGE_YAML,       @language ],
                                       [ CATEGORIES_YAML,     @categories ],
                                       [ EVENT_YAML,          @event ],
                                       [ URGENCY_YAML,        @urgency ],
                                       [ SEVERITY_YAML,       @severity ],
                                       [ CERTAINTY_YAML,      @certainty ],
                                       [ AUDIENCE_YAML,       @audience ],
                                       [ EFFECTIVE_YAML,      @effective ],
                                       [ ONSET_YAML,          @onset ],
                                       [ EXPIRES_YAML,        @expires ],
                                       [ SENDER_NAME_YAML,    @sender_name ],
                                       [ HEADLINE_YAML,       @headline ],
                                       [ DESCRIPTION_YAML,    @description ],
                                       [ INSTRUCTION_YAML,    @instruction ],
                                       [ WEB_YAML,            @web ],
                                       [ CONTACT_YAML,        @contact ],
                                       [ EVENT_CODES_YAML,    @event_codes.inject({}, &parameter_to_hash )],
                                       [ PARAMETERS_YAML,     @parameters.inject({}, &parameter_to_hash )],
                                       [ RESOURCES_YAML,      @resources ],
                                       [ AREAS_YAML,          @areas ]).to_yaml( options )
      end

      LANGUAGE_KEY       = 'language'       
      CATEGORIES_KEY     = 'categories'     
      EVENT_KEY          = 'event'          
      URGENCY_KEY        = 'urgency'        
      SEVERITY_KEY       = 'severity'       
      CERTAINTY_KEY      = 'certainty'      
      AUDIENCE_KEY       = 'audience'       
      EFFECTIVE_KEY      = 'effective'      
      ONSET_KEY          = 'onset'          
      EXPIRES_KEY        = 'expires'        
      SENDER_NAME_KEY    = 'sender_name'    
      HEADLINE_KEY       = 'headline'       
      DESCRIPTION_KEY    = 'description'    
      INSTRUCTION_KEY    = 'instruction'    
      WEB_KEY            = 'web'            
      CONTACT_KEY        = 'contact'        
      RESOURCES_KEY      = 'resources'      
      EVENT_CODES_KEY    = 'event_codes'    
      PARAMETERS_KEY     = 'parameters'     
      AREAS_KEY          = 'areas'          

      # @return [Hash]
      def to_h 
        RCAP.attribute_values_to_hash( [ LANGUAGE_KEY,      @language ],
                                       [ CATEGORIES_KEY,     @categories ],
                                       [ EVENT_KEY,          @event ],
                                       [ URGENCY_KEY,        @urgency ],
                                       [ SEVERITY_KEY,       @severity ],
                                       [ CERTAINTY_KEY,      @certainty ],
                                       [ AUDIENCE_KEY,       @audience ],
                                       [ EFFECTIVE_KEY,      RCAP.to_s_for_cap( @effective )],
                                       [ ONSET_KEY,          RCAP.to_s_for_cap( @onset )],
                                       [ EXPIRES_KEY,        RCAP.to_s_for_cap( @expires )],
                                       [ SENDER_NAME_KEY,    @sender_name ],
                                       [ HEADLINE_KEY,       @headline ],
                                       [ DESCRIPTION_KEY,    @description ],
                                       [ INSTRUCTION_KEY,    @instruction ],
                                       [ WEB_KEY,            @web ],
                                       [ CONTACT_KEY,        @contact ],
                                       [ RESOURCES_KEY,      @resources.map{ |resource| resource.to_h } ],
                                       [ EVENT_CODES_KEY,    @event_codes.map{ |event_code| event_code.to_h } ],
                                       [ PARAMETERS_KEY,     @parameters.map{ |parameter| parameter.to_h } ],
                                       [ AREAS_KEY,          @areas.map{ |area| area.to_h }])
      end
    end
  end
end