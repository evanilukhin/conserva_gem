require 'spec_helper'
describe Conserva do

  context 'when api_key valid' do
    before {Conserva.initialize('test-conserva-gem:1/', '2195038e-c3f4-48bb-94a5-65c7739c10e8')}

    it 'stubbed rest info found' do
      expect { Conserva.task_info(1) }.to_not raise_error
    end

    it 'stubbed rest info not found' do
      expect { Conserva.task_info(53) }.to raise_error(WrongResourceException)
    end

    it 'should send file' do
      Conserva.create_task(File.new('files/input.txt'),'pdf')
    end

    it 'should download file' do
      Conserva.download_file(1,'result.pdf','/tmp')
    end

    it 'should get converted pairs' do
      Conserva.valid_file_convertations
    end
  end


end