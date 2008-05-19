module Spec
  module Ultrasphinx
    module Matchers
      class BeIndexed
        
        def matches?(target)
          @target, @alert = target, nil
          if model_conf = ::Ultrasphinx::MODEL_CONFIGURATION[target.name]
            defined_fields = model_conf['fields'].map {|h| h['field']}
            if @fields
              if defined_fields.size > 0 
                if _wrong_fields? defined_fields
                  @alert = "#{@target} expected to be indexed by fields #{_fields_to_s(@fields)}" +
                                     " but indexed by #{_fields_to_s(defined_fields)}"
                end
              else
                @alert = "#{@target} expected to be indexed by fields #{_fields_to_s(@fields)}"
                                     " but is not indexed by any field"
              end
            end
            
            unless @delta.nil?
              if @delta.is_a? Hash
                if model_conf['delta'].nil?
                  @alert = "#{@target} expected to be indexed with delta using #{@delta[:field]} field"
                elsif model_conf['delta']['field'] != @delta[:field]
                  @alert = "#{@target} expected to be indexed with delta using #{@delta[:field]} field" +
                                      " but is using #{model_conf['delta']['field']} field"
                end
              else
                if @delta and model_conf['delta'].nil?
                  @alert = "#{@target} expected to be delta indexed"
                elsif !@delta and model_conf['delta']
                  @alert = "#{@target} not expected to be delta indexed"
                end
              end
            end  
          else
            @alert = "#{@target} expected to be indexed"
          end
          @alert.nil?
        end

        def failure_message
          @alert
        end

        def negative_failure_message  
        end

        def using_fields(fields)
          @fields = if fields.is_a? Array
            fields
          else
            [fields]
          end
          self
        end

        def with_delta(delta = true)
          @delta = if delta.is_a? Hash
            { :field => (delta[:field] || delta['field']).to_s }
          else  
            delta # true or false
          end
          self
        end
        
        private
          def _wrong_fields?(fields)
            (fields.size != @fields.size) or
              @fields.find { |f| fields.find {|e| e.to_s == f.to_s}.nil? }
          end
          
          def _fields_to_s(fields)
            "[:#{fields.join(', :')}]"
          end

      end

      def be_indexed
        BeIndexed.new
      end
    end
  end
end