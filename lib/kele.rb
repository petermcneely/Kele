require 'httparty'
require 'json'
require 'roadmap'

class Kele
	include HTTParty
	include Roadmap
	base_uri "https://www.bloc.io/api/v1"
	attr_accessor :auth_token

	def initialize email, password
		response = self.class.post '/sessions', body: {email: email, password: password} 
		if response['auth_token'].nil?
			raise ArgumentError, response['message']
		else
			@auth_token = response['auth_token']
		end
	end

	def get_me
		response = self.class.get '/users/me', headers: {'authorization' => @auth_token}
		JSON.parse(response.body)
	end

	def get_mentor_availability mentor_id
		response = self.class.get "/mentors/#{mentor_id}/student_availability", headers: {'authorization' => @auth_token}
		JSON.parse(response.body)
	end

	def get_messages page_id = -1
		if page_id == -1
			page_id = 1
			response = get_response page_id
			response_array = []
			while !response.parsed_response["items"].empty?
				response_array << JSON.parse(response.body)
				page_id += 1
				response = get_response page_id
			end
			response_array
		else
			response = get_response page_id
			JSON.parse(response.body)
		end
	end

	def create_message user_id, recipient_id, subject, stripped_text, token = ""
		body = {
			'user_id': user_id.to_s,
			'recipient_id': recipient_id.to_s, #Looks like this must be different from the user_id.
			'subject': subject, #Looks like this is needed.
			'stripped-text': stripped_text
		}
		
		body['token'] = token unless token.empty?

		response = self.class.post "/messages", headers: {'authorization' => @auth_token}, body: body
		begin
			JSON.parse(response.body)
		rescue JSON::ParserError
			response.body
		end
	end

	def create_submission checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id
		body = get_submission_body checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id
		response = self.class.post "/checkpoint_submissions", headers: {'authorization' => @auth_token}, body: body
		begin
			JSON.parse(response.body)
		rescue JSON::ParserError
			response.body
		end
	end

	def update_submission submission_id, assignment_branch, assignment_commit_link, checkpoint_id, comment, enrollment_id
		body = get_submission_body checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id
		response = self.class.put "/checkpoint_submissions/#{submission_id}", headers: {'authorization'=> @auth_token}, body: body
		begin
			JSON.parse(response.body)
		rescue JSON::ParserError
			response.body
		end
	end

	private
	def get_response page_id
		self.class.get "/message_threads", headers: {'authorization' => @auth_token}, body: {'page' => page_id.to_s}
	end

	def get_submission_body checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id
		body = {
			'checkpoint_id': checkpoint_id.to_s,
			'assignment_branch': assignment_branch,
			'assignment_commit_link': assignment_commit_link,
			'comment': comment,
			'enrollment_id': enrollment_id.to_s
		}
		body
	end
end