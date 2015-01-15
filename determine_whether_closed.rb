# This sript simply checks all stackoverflow ID's to see if the question in fact was closed
# Pass the id's to check as command line arguments, separated with spaces
#
# The script returns the number of closed and the number of non-closed questions

# The nokogiri gem is required. Run `gem install nokogiri` and it will be installed
# In case it won't, simply Google the error message. Unfortunately it has quite some dependencies

require 'nokogiri'
require 'open-uri'

closed = 0
non_closed = 0
i = 0
ARGV.each do |id|
  begin
    page = Nokogiri::HTML(open("http://stackoverflow.com/questions/#{id}"))
    begin
      if page.css('.special-status')[0].css('b').text == 'closed'
        closed += 1
      else
        non_closed += 1
      end
    rescue
      non_closed += 1
    end
  rescue
    p "Failure occurred at id #{id}. Skipping it."
  end
  sleep(0.8)
  i =+ 1

  if i % 10000 == 0
    p "--"
    p "at #{i} checks:"
    p "#{closed} of the questions were closed"
    p "#{non_closed} of the questions were not closed"
    p "#{closed*100/(closed+non_closed)}% of the total number questions were closed"
  end
end

p "--"
p "--"
p "Final results after #{i} checks:"

p "#{closed} of the questions were closed"
p "#{non_closed} of the questions were not closed"
p "#{closed*100/(closed+non_closed)}% of the total number questions were closed"
