require 'spec_helper'
describe Conserva do

  context 'correct working' do
    before {Conserva.initialize('test-conserva-gem:1/', '2195038e-c3f4-48bb-94a5-65c7739c10e8')}

    it 'should get info' do
      expect(Conserva.task_info(1)).to eq({source_file: '1464164329156_input.txt',
                                           converted_file: '1464164329156_input.txt',
                                           input_extension: 'txt',
                                           output_extension: 'txt',
                                           state: 'succ',
                                           created_at: '2016-05-25 11:18:49 +0300',
                                           updated_at: '2016-05-25 11:18:50 +0300',
                                           finished_at: '2016-05-25 11:18:50 +0300',
                                           source_file_sha256:'5cd3aca2394b25e57526c0ebb6934710e426e403db1974d7dff785cf8bcdea25',
                                           result_file_sha256:'5cd3aca2394b25e57526c0ebb6934710e426e403db1974d7dff785cf8bcdea25'})
    end

    it 'should send file' do
      expect(Conserva.create_task(File.new("#{File.dirname(__FILE__)}/files/input.txt"),'tzt', 'txt')).to eq(1)
    end

    it 'should download file' do
      downloaded_file = Conserva.download_file(1, check_sum: false)
      checksum_downloaded_file = Digest::SHA256.hexdigest(downloaded_file)
      expect(checksum_downloaded_file).to eq('5cd3aca2394b25e57526c0ebb6934710e426e403db1974d7dff785cf8bcdea25')
    end

    it 'should get converted pairs' do
      expect(Conserva.valid_file_convertations).to eql([%w(txt txt), %w(doc pdf)])
    end
  end

  context 'forwarding exceptions' do
    it 'should intercept not authorized' do
      expect { Conserva.task_info(2) }.to raise_error(Conserva::PermissionDenied)
      end
    it 'should intercept server error' do
      expect { Conserva.task_info(3) }.to raise_error(Conserva::ServerError)
    end

    it 'should intercept not found task' do
      expect { Conserva.task_info(5) }.to raise_error(Conserva::WrongResource)
    end

    it 'should intercept not acceptable' do
      expect { Conserva.create_task(File.new("#{File.dirname(__FILE__)}/files/input.txt"),'txt', 'pdf') }.to raise_error(Conserva::InvalidRequest)
    end

    it 'should intercept wrong parameters' do
      expect { Conserva.create_task(File.new("#{File.dirname(__FILE__)}/files/input.txt"),'txt', 'tmp') }.to raise_error(Conserva::WrongParameters)
    end

    it 'should task locked exception' do
      expect { Conserva.remove_task(2) }.to raise_error(Conserva::TaskLocked)
    end

    it 'should rised downloaded error' do
      expect { Conserva.download_file(4) }.to raise_error(Conserva::DownloadError)
    end

  end


end