module Intacct
  module Models
    class Timesheet < Intacct::Base

      def create_xml(xml)
        xml.employeeid attributes.employeeid
        xml.begindate {
          xml.year attributes.begindate.try(:strftime, "%Y")
          xml.month attributes.begindate.try(:strftime, "%m")
          xml.day attributes.begindate.try(:strftime, "%d")
        }
        xml.timesheetdescription attributes.timesheetdescriptiontime

        xml.timesheetitems {
          attributes.timesheetitems.each { |timesheetitem|
            xml.timesheetitem {
              xml.customerid timesheetitem[:customerid]
              xml.itemid timesheetitem[:itemid]
              xml.projectid timesheetitem[:projectid]
              xml.taskname timesheetitem[:taskname]
              xml.timetype timesheetitem[:timetype]
              xml.locationid timesheetitem[:locationid]
              xml.departmentid timesheetitem[:departmentid]
              xml.entrydate {
                xml.year timesheetitem[:entrydate].try(:strftime, "%Y")
                xml.month timesheetitem[:entrydate].try(:strftime, "%m")
                xml.day timesheetitem[:entrydate].try(:strftime, "%d")
              }
              xml.qty timesheetitem[:qty]
              xml.timesheetentrydescription timesheetitem[:timesheetentrydescription]
              xml.notes timesheetitem[:notes]
              xml.vendorid timesheetitem[:vendorid]
              xml.classid timesheetitem[:classid]

              if attributes.customfields
                xml.customfields {
                  attributes.customfields.each { |customfield|
                    xml.customfield {
                      xml.customfieldname customfield[:customfieldname]
                      xml.customfieldvalue customfield[:customfieldvalue]
                    }
                  }
                }
              end
            }
          }
        }
      end

      def update_xml(xml)
        create_xml(xml)
      end
    end
  end
end