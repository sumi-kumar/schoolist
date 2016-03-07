class School < ActiveRecord::Base

	GOOGLE_API_ACCESS_KEY = "AIzaSyCqoCB2bRluzdFojZq-iQBPzdojsqBtcFA"

	before_save :get_zip

	def get_zip
		# exec "curl 	https://maps.googleapis.com/maps/api/geocode/json?address=#{self.city.gsub(' ', '+')}&key=AIzaSyCqoCB2bRluzdFojZq-iQBPzdojsqBtcFA"
		response = `curl 	https://maps.googleapis.com/maps/api/geocode/json?address=#{self.city.gsub(' ', '+')}&key=AIzaSyCqoCB2bRluzdFojZq-iQBPzdojsqBtcFA`
		json_response = JSON.parse(response)
		self.zip = get_zip_from_response(json_response)
	end

	def get_zip_from_response(json_response)
		zip_object = json_response["results"].first["address_components"].select { |element| element["types"] == ["postal_code"] }
		zip_object.first["long_name"]
	end
	
	def self.search(search)
	  if search
	    first_school = School.where('name LIKE ?', "%#{search}%").order('name').first
	    rest_schools = School.where('name LIKE ? and id is not ?', "%#{search}%", first_school.id).order('name')
	  else
	    first_school = School.order('name').first
	    rest_schools = School.where('id is not ?', first_school.id).order('name')
	  end
	  return first_school, rest_schools
	end
end

