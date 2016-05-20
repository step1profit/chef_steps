# require 'thwait'

module ChefSteps
  class Parser
    attr_accessor :email_array, :number_of_threads, :filename, :final_hash, :final_array

    DEFAULT_NUMBER_OF_THREADS = 10

    class EmptyFileError < StandardError; end
    class EmptyInputError < StandardError; end
    class InvalidInputError < StandardError; end
    class InputError < StandardError; end
    class OptionError < StandardError; end

    # @overload initialize(*options)
    #   @param [Hash] *options for custom configuration
    #   @option *options [String] :filename of file containing line delimited email strings
    #   @option *options [Integer] :number_of_threads positive_integer for number of threads used running the parse
    #   @return [ChefSteps::Parser]
    def initialize(*options)
      @opts = options.extract_options!
      @final_hash = {}
      @final_array = []
      @email_array = []
      @filename = @opts.fetch(:filename, nil)
      @number_of_threads = @opts.fetch(:number_of_threads, DEFAULT_NUMBER_OF_THREADS)
    end

    # parses file; remove duplicates; creates unique email array while preserving order of occurrence in list
    #
    # @return [Array] newly populated array :final_array of emails in order
    def parse!
      file_to_lines!
      runner!
      sort_email!
    end

    # read input file of line delimited email strings and convert to array
    #
    # @return [Array] newly populated array :email_array of parsed emails and corresponding order number
    def file_to_lines!
      raise InvalidInputError, ":filename required" if @filename.class != String
      raise InvalidInputError, "bad :filename => #{@filename}" unless File.exist? @filename

      @email_array = IO.readlines(@filename).each_with_index.map {|x,i| [x.chomp,i]}
      #i = -1
      #@email_array = IO.readlines(@filename).map {|x| [x.chomp,i+=1]}

      raise EmptyFileError, 'no emails found in supplied :filename' if @email_array.empty?

      return @email_array
    end

    # multithread runner for #check_email!
    #
    # @return [True] only returns true
    def runner!
      raise EmptyInputError, ':email_array is empty; run #file_to_lines! first' if @email_array.empty?
      raise OptionError, ':number_of_threads requires a positive integer' unless @number_of_threads.integer? and @number_of_threads > 0

      waiter = ThreadsWait.new([])

      @number_of_threads.times do |i|
        waiter.join_nowait(Thread.new {
          until @email_array.empty? do
            check_email!
          end
        })
      end

      waiter.all_waits

      return true
    end

    # pop single email from email array; add it to hash using email string as key and order number as value
    #   this method used exclusively in #runner!
    #
    # @return [nil]
    def check_email!
      x,y = @email_array.pop

      # val remains same as original
      @final_hash[x] = (@final_hash[x].nil? or @final_hash[x] > y) ? y : @final_hash[x]

      return nil
    end

    # sort parsed emails in order of occurrence; invert to array, sort by order number, convert to hash, and return only email values
    #
    # @return [Array] email strings in array :final_array sorted by occurrence in list
    def sort_email!
      raise EmptyInputError, ':final_hash is empty' if @final_hash.empty?

      @final_array = @final_hash.invert.sort.to_h.values
    end

    # writes line delimited email list to file
    #
    # return [File] line delimited email list
    def write(output_filename)
      raise EmptyInputError, ':final_array is empty; run #sort_email! first' if @final_array.empty?

      f = File.new(output_filename, "w+")
      f.write(@final_array.join("\n"))
      return f
    end
  end
end
