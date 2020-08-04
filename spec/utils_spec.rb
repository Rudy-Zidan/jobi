module Jobi
  RSpec.describe Utils do
    let(:dummy_class) do
      Class.new { extend Utils }
    end

    let(:uuid_regex) do
      /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    end

    context 'constantize' do
      it 'should return constant name of a string' do
        constant = dummy_class.constantize('String')

        expect(constant).to be(String)
      end
    end

    context 'generate_job_id' do
      it 'should return correct uuid' do
        uuid = dummy_class.generate_job_id
        result = uuid_regex.match?(uuid)

        expect(result).to be_truthy
      end
    end
  end
end