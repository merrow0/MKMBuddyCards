require 'rubygems'
require 'nokogiri'
require 'sinatra'
require 'open-uri'
require 'net/https'

BASE_MKM_URL = "https://www.magickartenmarkt.de/"
# 35053->Steffen, 37088->Jochen, 38738->Bruno, 37873->Marc,
# 38001->JJ, 39433->Lukas, 39249->Peter
USER_ID = [	["38738", "Bruno"],
			["37088", "Jochen"],
			["117171", "Jacky"],
			["38001", "JJ"],
			["39433", "Lukas"],
			["37873", "Marc"],
			["39249", "Peter"],
			["35053", "Steffen"]]

get '/' do
	erb :index
end

post '/' do
	@card = params[:card]
	lcard = @card.gsub(" ", "+")

	@result_hash = Hash.new

	USER_ID.each do |uid|
		url = "#{BASE_MKM_URL}?mainPage=browseUserProducts&idCategory=1&idUser=#{uid[0]}&cardName=" + lcard
		page = Nokogiri::HTML(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
	  
		rows = page.css('table.MKMTable.specimenTable tbody tr')
		rows_ary = Array.new

		rows_ary.push(url)

		rows.each do |row|
			row_ary = Array.new

			row_ary.push(row.css(".col_2 a")[0]["href"])
			row_ary.push(row.css(".col_2").text)
			row_ary.push(row.css(".col_4").css("img")[0]["alt"])
			row_ary.push(row.css(".col_6").css("img")[0]["alt"])

			foil = false
			if !row.css(".col_7").css("img")[0].nil?
				foil = true
			end
			row_ary.push(foil)
			row_ary.push(row.css(".col_9").text)
			row_ary.push(row.css(".col_10").text)

			rows_ary.push(row_ary)
		end

		@result_hash[uid[1]] = rows_ary
	end

	erb :result
end

get '/about' do
	erb :about
end

get '/bargain' do
	page = Nokogiri::HTML(open(BASE_MKM_URL, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
	@rows = page.css(".startPage_Middle .startPageTable tbody tr")

	erb :bargain
end