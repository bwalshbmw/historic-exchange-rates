# Controller for managing the data passed to the historic rates chart.
class ChartsController < ApplicationController
  def historic_rates
    render json: series_data.chart_json
  end

  private

  # Placeholder data used to set up the initial chart. Will be replaced with
  # data from the API. -BW 02/08/2019
  def series_data
    [euro_data, usd_data, aud_data]
  end

  def euro_data
    { name: 'EUR',
      data: {
        '2018-01-02': 0.2531389226,
        '2018-01-03': 0.2548679784,
        '2018-01-04': 0.256016385,
        '2018-01-05': 0.2560360499
      } }
  end

  def usd_data
    { name: 'USD',
      data: {
        '2018-01-02': 0.3054121102,
        '2018-01-03': 0.3064277704,
        '2018-01-04': 0.3088837686,
        '2018-01-05': 0.3083954221
      } }
  end

  def aud_data
    { name: 'AUD',
      data: {
        '2018-01-02': 0.3901630215,
        '2018-01-03': 0.390941992,
        '2018-01-04': 0.3942140297,
        '2018-01-05': 0.3932969762
      } }
  end
end
