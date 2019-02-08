require 'rails_helper'

RSpec.describe 'exchange_rates/index' do
  it 'should render the index template' do
    render

    expect(view).to render_template(:index)
  end

  it 'should display the page title' do
    render plain: 'Historic Exchange Rates'

    expect(rendered).to match('Historic Exchange Rates')
  end

  it 'should display the exchange rate line chart partial' do
    render partial: 'exchange_rate_graphs/_line_chart.html.erb'

    expect(rendered).to include(partial)
  end
end
