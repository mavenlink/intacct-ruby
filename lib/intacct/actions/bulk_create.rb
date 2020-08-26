module Intacct
  module Actions
    class BulkCreate < Base
      def request(new_records)
        Intacct::XmlRequest.build_xml(client, action) do |xml|
          xml.function(controlid: "1") do
            xml.create do
              new_records.each do |new_record|
                xml.send(klass.api_name) do
                  new_record.each do |key, value|
                    xml.send(key, value)
                  end
                end
              end
            end
          end
        end
      end

      def response_body
        raw = @response.at("//result/data")
        return unless raw

        parsed = Hash.from_xml(raw.to_xml)["data"][list_type]
        return unless parsed

        if parsed.is_a?(Array)
          parsed.map(&:values).flatten
        else
          parsed.values
        end
      end

      def list_type
        klass.api_name.singularize
      end

      def response_errors
        raw = @response.at("//result/errormessage")
        return [] unless raw

        Hash.from_xml(raw.to_xml)["errormessage"]["error"]
      end

      module Helper
        extend ActiveSupport::Concern

        module ClassMethods
          def bulk_create(client, attributes)
            response = Intacct::Actions::BulkCreate.new(client, self, "bulk_create",
                                                        attributes).perform

            @errors = response.errors

            raise Intacct::Error, formatted_error_message(response.errors) unless response.success?

            response.body
          end
        end
      end
    end
  end
end
