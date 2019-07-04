module SearchesHelper
  BASE_URL = "http://ws.audioscrobbler.com/2.0/?method="
  API_METHODS = ["artist.getinfo", "artist.getTopTracks"]
  API_KEY = "5345e29b04545726f5be7dae7acb9032"
  JSON_FORMAT = "&format=json"

  def get_artistInfo(search_query)
    @artist = Hash.new

    api_parameters = {artist: search_query, api_key: API_KEY}
    info_response = HTTParty.get(BASE_URL + API_METHODS[0] + JSON_FORMAT, query: api_parameters)
    info_response = JSON.parse(info_response.body, symbolize_names: true)
    api_parameters[:limit] = 10
    track_response = HTTParty.get(BASE_URL + API_METHODS[1] + JSON_FORMAT, query: api_parameters)
    track_response = JSON.parse(track_response.body, symbolize_names: true)

    # If any of the responses contains an error,
    if info_response[:error]
      @artist[:error] = info_response[:error]
      @artist[:message] = info_response[:message]
      return
    end
    if track_response[:error]
      @artist[:error] = track_response[:error]
      @artist[:message] = track_response[:message]
      return
    end

    @artist[:name] = info_response[:artist][:name]
    @artist[:url] = info_response[:artist][:url]
    @artist[:bio] = info_response[:artist][:bio][:summary]
    @artist[:similar] = []
    info_response[:artist][:similar][:artist].each do |similar_artist|
      @artist[:similar].push({name: similar_artist[:name], url: similar_artist[:url]})
    end
    @artist[:tracks] = []
    track_response[:toptracks][:track].each do |track|
      @artist[:tracks].push({name: track[:name], url: track[:url]})
    end
  end
end
