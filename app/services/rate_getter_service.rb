require 'net/http'
require 'json'

# Simple PORO class responsible from getting historic exchange rates for the
# given currencies from the Exchange Rates API.
class RateGetterService
  def self.get_rates(currencies)
    new(currencies).retrieve_and_prepare_data
  end

  def initialize(currencies)
    @currencies = currencies
  end

  def retrieve_and_prepare_data
    api_request
    reorder_json_data(format_data_to_json)
    setup_series_data
  end

  def euro_data
    @euro_data ||= {}
  end

  def usd_data
    @usd_data ||= {}
  end

  def aud_data
    @aud_data ||= {}
  end

  def api_request
    uri = URI(build_request_url)
    Net::HTTP.get(uri)
  end

  def format_data_to_json
    JSON.parse(api_request)
  end

  # rubocop:disable Metrics/MethodLength
  def reorder_json_data(json_data)
    sequential_rates = json_data['rates'].sort.to_h
    sequential_rates.each do |date, rate_hash|
      rate_hash.each do |currency, exchange_rate|
        if currency == 'EUR'
          euro_data[date] = exchange_rate
        elsif currency == 'USD'
          usd_data[date] = exchange_rate
        elsif currency == 'AUD'
          aud_data[date] = exchange_rate
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def setup_series_data
    [euro_series, usd_series, aud_series].compact
  end

  def euro_series
    return nil if euro_data.empty?

    { name: 'EUR', data: euro_data, color: ['#fdb827'] }
  end

  def usd_series
    return nil if usd_data.empty?

    { name: 'USD', data: usd_data, color: ['#bf0a30'] }
  end

  def aud_series
    return nil if aud_data.empty?

    { name: 'AUD', data: aud_data, color: ['#00008b'] }
  end

  def build_request_url
    [
      'https://api.exchangeratesapi.io/history?start_at=',
      request_start_date,
      '&end_at=',
      request_end_date,
      '&base=',
      base_currency,
      '&symbols=',
      @currencies
    ].join
  end

  def request_start_date
    (Date.today - 1.year).to_s
  end

  def request_end_date
    Date.today.to_s
  end

  def base_currency
    'BRL'
  end
end
