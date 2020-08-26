module Intacct
  module Actions
    class Update < Base
      def request(_options)
        Intacct::XmlRequest.build_xml(client, action) do |xml|
          xml.function(controlid: "1") do
            xml.update do
              xml.send(klass.api_name) do
                klass.update_xml(xml)
              end
            end
          end
        end
      end

      def response_body
        nil
      end

      def list_type
        nil
      end

      def response_errors
        raw = @response.at("//result/errormessage")
        return unless raw

        Hash.from_xml(raw.to_xml)["errormessage"]["error"]
      end

      module Helper
        def update(options = {})
          response = Intacct::Actions::Update.new(client, self, "update", options).perform

          @errors = response.errors

          response.success?
        end
      end
    end
  end
end
