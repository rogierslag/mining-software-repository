require 'tiny_tds'
require 'open-uri'
require 'net/http'
require "erb"
include ERB::Util

def to_text(so_input)
	so_input.gsub(/<code>.*?<\/code>/, '').gsub(%r{</?[^>]+?>}, '').gsub(/\n/, '')
end

def classification(input)
	res = `cd ~/Downloads && echo "#{input.gsub('"','').gsub('`','')}" | java -jar SentiStrength.jar sentidata ./SentStrength_Data_Sept2011/ scale stdin`
	return res.split(' ')[2].to_i
end
	

client = TinyTds::Client.new username: 'MSRChallenge', password: 'IN4334', host: 'vanilla.xyclade.nl', database: 'MSRChallenge', timeout: 3600

result = client.execute("SELECT top 10000 question.id as id, question.body as question, response.body as answer FROM posts question left join posts response on question.acceptedanswerid=response.id where question.posttypeid=1 and question.owneruserid in (select users.id from users left join posts on posts.owneruserid = users.id group by users.id having count(posts.id) > 2) and response.body is not null and response.body != ''")

questions = []
answers = []
result.each do |row|
	questions << classification(to_text(row['question']))
	answers << classification(to_text(row['answer']))
end



p "Average question nicenes: #{questions.inject{ |sum, el| sum + el }.to_f / questions.size}"
p "Average answer nicenes: #{answers.inject{ |sum, el| sum + el }.to_f / answers.size}"
