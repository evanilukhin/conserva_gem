# Conserva
Ruby gem for Convert Service AWESOME"
Gem for work with convert service - conserva."

Before working get personal API key. Оnly user who create task can get information, remove and download task.

## Base functions
Before work gem must initialized. By default proxy initialized as nil. Example:
```ruby
Conserva.initialize('123.123.123.123:1234', '2195038e-c3f4-48bb-94a5-65c7739c10e8')

Conserva.initialize('123.123.123.123:1234', '2195038e-c3f4-48bb-94a5-65c7739c10e8', proxy: '1.1.1.1:3000')
```
For getting all possible combinations for conversion should use:
```ruby
Conserva.valid_file_convertations
➔ [[doc, pdf], [txt, pdf], [bmp, jpg]]
```

For creating task on server:
```ruby
Conserva.create_task(File.new('/home/evan/test_file.txt'),'txt', 'pdf')
➔ 1034
```

Getting information about created task:
```ruby
Conserva.task_info(1034)
➔ {"source_file"=>"1466583406242_test_file.txt", "converted_file"=>nil, "input_extension"=>"txt", "output_extension"=>"pdf", "state"=>"rec", "created_at"=>"2016-06-22 11:16:46 +0300", "updated_at"=>nil, "finished_at"=>nil, "source_file_sha256"=>"5cd3aca2394b25e57526c0ebb6934710e426e403db1974d7dff785cf8bcdea25", "result_file_sha256"=>nil}
```
Checking task readness:
```ruby
Conserva.task_ready?(identifier_task)
```

Downloading file. By default, gem verify downloaded file by comparsion checksum. For disabling validation, should add to options, check_sum: false.
Two examples:
```ruby
# downloading file with verification
file_data = Conserva.download_file(1234)
File.open('local_file.pdf', "w") do |file|
   file.write(file_data)
end

# downloading file without verification
file_data = Conserva.download_file(1235, check_sum: false)
```
Removing task. If task in progress, will be thrown exception `Conserva::TaskLocked`.
```ruby
Conserva.remove_task(identifier_task)
```
## Exceptions

All exceptions inherited from base class `Conserva::ConvertError`.

## Example usage

```ruby
require 'conserva'
require 'digest'

begin
    conserva_address = '123.123.123.123:1234'
    api_key = '2195038e-c3f4-48bb-94a5-65c7739c10e8'
    proxy = '1.1.1.1:3000'

    Conserva.initialize(conserva_address, api_key, proxy: proxy)

    identifier_task = Conserva.create_task(File.new('/home/evan/test_file.txt'),'txt', 'pdf')
    ➔ 1234

    if Conserva.task_ready?(identifier_task)
        file_data = Conserva.download_file(identifier_task)
        File.open('local_file.pdf', "w") do |file|
           file.write(file_data)
        end
    end

    Conserva.task_info(indentifier_task)
    ➔ { "source_file" => "1466583406242_test_file.txt",
        "converted_file" => "1466583406242_test_file.pdf",
        "input_extension" => "txt",
        "output_extension" => "pdf",
        "state" => "succ",
        "created_at" => "2016-06-22 11:16:46 +0300",
        "updated_at" => 2016-06-22 11:16:47 +0300,
        "finished_at" => 2016-06-22 11:16:47 +0300,
        "source_file_sha256" => "5cd3aca2394b25e57526c0ebb6934710e426e403db1974d7dff785cf8bcdea25",
        "result_file_sha256" => "3c9ba016f68cee0e5124467ba2d15ad8c2e94e72941f7ac1dc40564e80b7e9ad"
      }

    Conserva.remove_task(identifier_task)
rescue Conserva::ConvertError => exception
    # handling Conserva exceptions
end
```