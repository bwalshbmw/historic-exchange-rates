require 'rails_helper'

RSpec.describe 'exchange_rates/index' do
  it 'should display the page title' do
    render plain: 'Historic Exchange Rates'

    expect(rendered).to match('Historic Exchange Rates')
  end

  it 'should display the exchange rate line chart partial' do
    render partial: 'exchange_rates/line_chart.html.erb'

    expect(response).to include('historic-exchange-rates-chart')
  end

  it 'should render the form for changing the charted currencies' do
    render partial: 'exchange_rates/form.html.erb'

    expect(response).to include('form')
  end
end
