# Conserva
Ruby gem for Convert Service AWESOME"
Gem for work with convert service - conserva."

## Example usage

```ruby
require 'conserva'
require 'digest'

conserva_address = '123.123.123.123:1234'
api_key = '2195038e-c3f4-48bb-94a5-65c7739c10e8'
proxy = '1.1.1.1:3000' # or nil

Conserva.initialize(conserva_address, api_key, proxy)

identifier_task = Conserva.create_task(File.new('/home/evan/test_file.txt'), 'pdf')
➔ 1234

if Conserva.task_ready?(identifier_task)
    file = Conserva.download_file(identifier_task, 'test_file.txt', '/home/evan/downloads')
    puts 'File successful downloaded' if Digest::SHA256.file(file).hexdigest == Conserva.task_info(identifier_task)
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
```

## Base functions
```ruby
Conserva.initialize(conserva_address, api_key, proxy = nil)
```

```ruby
Conserva.valid_file_convertations
➔ [[doc, pdf], [txt, pdf], [bmp, jpg]]
```

```ruby
Conserva.task_info(1034)
=> {"source_file"=>"1466583406242_LICENSE.txt", "converted_file"=>nil, "input_extension"=>"txt", "output_extension"=>"pdf", "state"=>"rec", "created_at"=>"2016-06-22 11:16:46 +0300", "updated_at"=>nil, "finished_at"=>nil, "source_file_sha256"=>"5cd3aca2394b25e57526c0ebb6934710e426e403db1974d7dff785cf8bcdea25", "result_file_sha256"=>nil}
```

```ruby
Conserva.create_task(File.new('/home/evan/test_file.txt'), 'pdf') => 1034
```
return identifier created task

```ruby
Conserva.task_ready?(identifier_task)
```

```ruby
Conserva.remove_task(identifier_task)
```