require 'spec_helper'

describe 'Kele', :vcr do
	let(:kele_instance) {Kele.new(ENV["KELE_USERNAME"], ENV["KELE_PASSWORD"])}

	it 'has an auth_token' do
		expect(kele_instance.auth_token).to_not be_nil
	end

	it 'logs the expected user in' do
		response = kele_instance.get_me
		expect(response["slug"]).to eq ENV["KELE_SLUG"]
	end

	it "gets the mentor's availability" do
		mentor_id = kele_instance.get_me["current_enrollment"]["mentor_id"]
		expect(kele_instance.get_mentor_availability mentor_id).to_not be_empty
	end

	it "gets a specific page of messages" do
		response = kele_instance.get_messages 1
		puts response
		expect(response["messages"]).to_not eq "Resource not found"
	end

	it "gets all pages messages" do
		response = kele_instance.get_messages
		puts response
		expect(response[0]["messages"]).to_not eq "Resource not found"
	end

	it "sends a message without token" do
		me = kele_instance.get_me
		subject = "Sent from Kele Test"
		text = "This message is sent from my rspec test."
		response = kele_instance.create_message me["id"], me["current_enrollment"]["mentor_id"], subject, text
		expect(response["success"]).to eq true
	end

	it "sends message with token" do
		me = kele_instance.get_me
		subject = "Sent from Kele Test"
		text = "This is another message sent from my rspec test. This time it is attaching to a current message thread."
		token = ENV["KELE_MESSAGE_TOKEN"]
		response = kele_instance.create_message me["id"], me["current_enrollment"]["mentor_id"], subject, text, token
		expect(response["success"]).to eq true
	end

	it "creates a submission" do
		enrollment_id = kele_instance.get_me["current_enrollment"]
		response = kele_instance.create_submission ENV["KELE_CHECKPOINT"], ENV["KELE_ASSIGNMENT_BRANCH"], ENV["KELE_ASSIGNMENT_COMMIT_LINK"], "Sent from Kele Test", enrollment_id
		puts response
	end

	it "updates a submission" do
		enrollment_id = kele_instance.get_me["current_enrollment"]
		response = kele_instance.update_submission ENV["KELE_SUBMISSION_ID"], ENV["KELE_ASSIGNMENT_BRANCH"], ENV["KELE_ASSIGNMENT_COMMIT_LINK"], ENV["KELE_CHECKPOINT"], "Updated from Kele Test", enrollment_id
		puts response
	end

	it "gets a roadmap" do
		expect(kele_instance.get_roadmap(1)["id"]).to eq 1
	end

	it "gets a checkpoint" do
		expect(kele_instance.get_checkpoint(1907)["id"]).to eq 1907
	end
end