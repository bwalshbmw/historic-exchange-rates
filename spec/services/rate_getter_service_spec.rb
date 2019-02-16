require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe RateGetterService, type: :service do
  let(:service) { RateGetterService.new('EUR,USD,AUD') }
  let(:sample_euro_data) { { '2019-01-02' => 0.2276348737 } }
  let(:sample_usd_data) { { '2019-01-02' => 0.2594354655 } }
  let(:sample_aud_data) { { '2019-01-02' => 0.3704302299 } }
  let(:euro_series) { service.euro_series }
  let(:usd_series) { service.usd_series }
  let(:aud_series) { service.aud_series }

  describe '#retrieve_and_prepare_data' do
    context 'when the service is called' do
      it 'should run each method required to retreive and prepare the data' do
        expect(service).to receive(:api_request)
        expect(service).to receive(:format_data_to_json)
        expect(service).to receive(:reorder_json_data)
        expect(service).to receive(:setup_series_data)

        service.retrieve_and_prepare_data
      end
    end
  end

  describe '#build_request_url' do
    context 'when given a specific currency' do
      it 'should be the url for API request using the given currency' do
        start_date = (Date.today - 1.year).to_s
        end_date = Date.today.to_s
        currency = 'USD'
        expected_url = ['https://api.exchangeratesapi.io/history?start_at=',
                        start_date,
                        '&end_at=',
                        end_date,
                        '&base=BRL',
                        '&symbols=USD'].join
        expect(RateGetterService.new(currency).build_request_url)
          .to eq expected_url
      end
    end
  end

  describe '#reorder_json_data' do
    context 'given the API response data as parsed json' do
      it 'should be reordered by currency with date and rate as data points' do
        example_data = {
          'base' => 'BRL',
          'end_at' => '2019-01-02',
          'start_at' => '2019-01-01',
          'rates' => {
            '2019-01-02' => {
              'USD' => 0.2594354655,
              'AUD' => 0.3704302299,
              'EUR' => 0.2276348737
            }
          }
        }

        service.reorder_json_data(example_data)

        expect(service.euro_data).to eq sample_euro_data
        expect(service.usd_data).to eq sample_usd_data
        expect(service.aud_data).to eq sample_aud_data
      end
    end
  end

  describe '#setup_series_data' do
    context 'when the user did not select a currency' do
      it 'should build the series data array' do
        allow(service)
          .to receive(:euro_data).with(any_args) { sample_euro_data }
        allow(service).to receive(:usd_data).with(any_args) { sample_usd_data }
        allow(service).to receive(:aud_data).with(any_args) { sample_aud_data }

        expect(service.setup_series_data)
          .to eq [euro_series, usd_series, aud_series]
      end
    end

    context 'when the user specified they wanted to see AUD currency rates' do
      it 'should only return series data for AUD' do
        allow(service).to receive(:aud_data).with(any_args) { sample_aud_data }

        expect(service.setup_series_data).to eq [aud_series]
      end
    end

    describe '#euro_series' do
      context 'when EUR was among the requested currencies' do
        it 'should convert it to the series data format needed for the chart' do
          allow(service)
            .to receive(:euro_data).with(any_args) { sample_euro_data }

          expect(euro_series[:name]).to eq 'EUR'
          expect(euro_series[:data]).to eq service.euro_data
          expect(euro_series[:color]).to eq ['#fdb827']
        end
      end

      context 'when EUR was not among the requested currencies' do
        it 'should return nil' do
          expect(euro_series).to be_nil
        end
      end
    end

    describe '#usd_series' do
      context 'when USD was among the requested currencies' do
        it 'should convert it to the series data format needed for the chart' do
          allow(service)
            .to receive(:usd_data).with(any_args) { sample_usd_data }

          expect(usd_series[:name]).to eq 'USD'
          expect(usd_series[:data]).to eq service.usd_data
          expect(usd_series[:color]).to eq ['#bf0a30']
        end
      end

      context 'when USD was not among the requested currencies' do
        it 'should return nil' do
          expect(usd_series).to be_nil
        end
      end
    end

    describe '#aud_series' do
      context 'when AUD was among the requested currencies' do
        it 'should convert it to the series data format needed for the chart' do
          allow(service)
            .to receive(:aud_data).with(any_args) { sample_aud_data }

          expect(aud_series[:name]).to eq 'AUD'
          expect(aud_series[:data]).to eq service.aud_data
          expect(aud_series[:color]).to eq ['#00008b']
        end
      end

      context 'when AUD was not among the requested currencies' do
        it 'should return nil' do
          expect(aud_series).to be_nil
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
