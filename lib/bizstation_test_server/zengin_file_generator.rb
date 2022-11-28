module BizstationTestServer
  class ZenginFileGenerator

    def initialize(submitted_filename, submitted_file_contents)
      @submitted_filename = submitted_filename
      @submitted_file_contents = submitted_file_contents.force_encoding('SHIFT_JIS')
    end

    def generate_receipt
      [ generate_filename(:receipt), generate_receipt_contents ]
    end

    def generate_result
      [ generate_filename(:result), generate_result_contents ]
    end

    # When we submit a zengin file with bank transfer to BizStation, they will
    # generate a receipt (受付結果) and result (処理結果) file for us to download.
    # The name will be the filename that we submitted, followed by a number followed
    # by an A for receipt and B for result. The number is the total amounts of
    # requests made to Bizstation by anyone. There is no way we can predict it so
    # we generate a random number for the test server.
    def generate_filename(response_type)
      suffixes = { receipt: 'A', result: 'B' }

      unless suffixes.keys.member?(response_type)
        raise ArgumentError, "response type must be one of %s. Got: %s" % [
          suffixes.keys,
          response_type.inspect
        ]
      end

      random_12_digit_number = '%010d' % rand(10**12)
      @submitted_filename + '_' + random_12_digit_number + suffixes[response_type]
    end

    # A successful BizStation receipt (受付結果) is almost identical to the submitted
    # zengin file but has a '000' code at the end of each line indicating the success
    # status. A non '000' code means something went wrong. For now we just generate a
    # successful receipt for everything.
    #
    # Simulating errors could be a cool feature for the future one day.
    def generate_receipt_contents
      @submitted_file_contents.lines.map do |line|
        new_line = line.dup

        new_line[115] = '0'
        new_line[116] = '0'
        new_line[117] = '0'

        new_line
      end.join
    end

    # A successful BizStation result (処理結果) takes the receipt and adds an extra
    # '00' line for each transfer, indicating success. A code other than '00' would
    # mean an error. It does not make any changes the the header and footer lines
    #
    # It could be cool to simulate failing transfers in the future but for now we
    # just let them all succeed.
    def generate_result_contents
      receipt_lines = generate_receipt_contents.lines

      (1..(receipt_lines.length - 3)).each do |i|
        receipt_lines[i][113] = '0'
        receipt_lines[i][114] = '0'
      end

      receipt_lines.join
    end
  end
end
