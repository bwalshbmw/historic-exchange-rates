# Controller for managing the data passed to the historic rates chart.
class ChartsController < ApplicationController
  def historic_rates
    @series_data = RateGetterService.get_rates(requested_currencies)
    render json: @series_data.chart_json
  end

  private

  def requested_currencies
    'EUR,USD,AUD'
  end
end
