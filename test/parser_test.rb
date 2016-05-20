require 'test_helper'

class ParserTest < Minitest::Test
  def setup
    # specify number of emails
    @number_of_emails = 50_000

    # generate new emails array
    emails_array = generate_emails(@number_of_emails)

    # create filename vars
    @files = File.join(File.expand_path(File.dirname(__FILE__)), "files")
    @test_file = File.join @files, 'emails.txt'
    @output_file = File.join @files, 'email_output.txt'

    # if a previous test file exists, then use opportunity to ensure diff generator
    if File.exist? @test_file
      old_emails = File.readlines(@test_file).each {|x| x.chomp!}

      # not the same order
      refute_equal old_emails, emails_array

      # not the same sets of strings in diff orders
      refute_equal old_emails.sort, emails_array.sort

      # same amount of uniq
      assert_equal old_emails.uniq.count, emails_array.uniq.count
    end

    # delete orig files
    FileUtils.rm_f @test_file
    FileUtils.rm_f @output_file

    # refute existance of orig files (redundant)
    refute File.exist? @test_file
    refute File.exist? @output_file

    # create test file from new emails array
    create_test_file(@test_file, emails_array)

    # assert test file was created
    assert File.exist? @test_file

    # create array of emails in test file
    @emails = File.readlines(@test_file).each {|x| x.chomp!}
  end

  # ChefSteps::Parser#new
  def test_init_parser_with_options
    parser = ChefSteps::Parser.new(:filename => @test_file)
    assert_kind_of(ChefSteps::Parser, parser)

    # ensure object formed correctly
    assert_equal @test_file, parser.filename
    assert_empty parser.email_array
    assert_empty parser.final_hash
    assert_empty parser.final_array
    assert_equal ChefSteps::Parser::DEFAULT_NUMBER_OF_THREADS, parser.number_of_threads
  end

  # ChefSteps::Parser#new
  def test_init_parser_without_options
    parser = ChefSteps::Parser.new
    assert_kind_of(ChefSteps::Parser, parser)

    # ensure object formed correctly
    assert_nil parser.filename
  end

  # ChefSteps::Parser#parse!
  def test_parse
    # create new parser
    parser = ChefSteps::Parser.new(:filename => @test_file)

    # ensure test file exists
    assert File.exist? parser.filename

    # ensure test setup has generated required support files correctly
    assert_equal @number_of_emails, @emails.uniq.count
    assert_equal @number_of_emails*2, @emails.count

    # call main test subject method
    assert parser.parse!

    # email array should have popped off until empty
    assert_empty parser.email_array

    # should contain populated hash
    refute_empty parser.final_hash

    # length should be the same
    assert_equal @number_of_emails, parser.final_hash.length

    # should contain populated array
    refute_empty parser.final_array

    # should contain all unique emails from file
    assert_equal @emails.uniq.sort, parser.final_array.sort
  end

  # ChefSteps::Parser#file_to_lines!
  def test_file_to_lines
    parser = ChefSteps::Parser.new(:filename => @test_file)

    # ensure object formed correctly
    assert File.exist? parser.filename
    assert_empty parser.email_array

    # ensure correct return
    act1 = parser.file_to_lines!
    assert_kind_of(Array, act1)
    act2 = act1[rand(act1.length)]
    assert_kind_of(Array, act2)

    # ensure indice populated in correct format
    assert_equal 2, act2.length
    assert_kind_of(String, act2[0])
    assert_kind_of(Integer, act2[1])

    # return should be the same as attribute
    assert_same parser.email_array, act1

    # :email_array should now be populated
    refute_empty parser.email_array
  end

  # ChefSteps::Parser#runner!
  def test_runner
    parser = ChefSteps::Parser.new

    assert_empty parser.email_array
    assert_empty parser.final_hash

    # manually populate :email_array
    assert_kind_of(Array, @emails)
    parser.email_array = @emails.each_with_index.map {|x,i| [x, i]}

    # main test subject
    parser.runner!

    # should be empty after calling runner
    assert_empty parser.email_array

    act1 = parser.final_hash
    assert_kind_of(Hash, act1)

    # should be polulated after calling runner
    refute_empty act1

    act2 = act1.key(rand(act1.length))
    assert_kind_of(String, act2)

    # should be in seed array
    assert @emails.include?(act2)
  end

  # ChefSteps::Parser#check_email!
  def test_check_email
    parser = ChefSteps::Parser.new

    assert_empty parser.email_array
    assert_empty parser.final_hash

    i1 = rand(1..@emails.length-10)
    i2 = i1+rand(10)
    emails = @emails.dup.uniq.shuffle
    e1 = emails.first
    e2 = emails.last

    # duplicate emails with different order number
    x = [e1,i2]
    y = [e1,i1]

    # uniq email
    z = [e2,0]

    # randomize
    parser.email_array = [x,y,z].shuffle

    assert_equal 3, parser.email_array.length

    # main test subject returns nil
    assert_nil parser.check_email!

    # check lengths
    assert_equal 2, parser.email_array.length
    assert_equal 1, parser.final_hash.length

    # check content
    act = parser.final_hash
    exp1 = {e2 => 0}
    exp2 = {e1 => i1}
    exp3 = {e1 => i2}
    assert [exp1, exp2, exp3].include?(act)

    # main test subject returns nil
    assert_nil parser.check_email!

    # check lengths
    assert_equal 1, parser.email_array.length
    assert [1,2].include?(parser.final_hash.length)

    # check content
    act = parser.final_hash
    exp4 = {e2 => 0, e1 => i1}
    exp5 = {e2 => 0, e1 => i2}
    assert [exp2, exp3, exp4, exp5].include?(act)

    # main test subject returns nil
    assert_nil parser.check_email!

    # check lengths
    assert_equal 0, parser.email_array.length
    assert_equal 2, parser.final_hash.length

    # check content; ensure i2 doesn't overwrite i1
    act = parser.final_hash
    exp = {e2 => 0, e1 => i1}
    assert_equal exp, act
  end

  # ChefSteps::Parser#sort_email!
  def test_sort_email
    parser = ChefSteps::Parser.new

    # ensure initial state
    assert_empty parser.final_hash
    assert_empty parser.final_array

    # populate final hash with seed data
    emails = @emails.dup.uniq.shuffle[0..rand(@emails.length)]
    h1 = {}
    emails.each_with_index do |x,i|
      h1[x] = i
    end
    parser.final_hash = h1

    # main test subject
    parser.sort_email!

    # check content
    act1 = parser.final_array
    assert_kind_of(Array, act1)
    refute_empty act1

    # check content at random indice
    act2 = act1[rand(act1.length)]
    assert_kind_of(String, act2)
    assert emails.include?(act2)

    # ensure all emails present
    assert_equal emails.sort, act1.sort

    # ensure final array is in order
    h2 = {}
    act1.each_with_index do |x,i|
      h2[x]= i
    end
    assert_equal h1, h2
  end

  # ChefSteps::Parser#write
  def test_write
    parser = ChefSteps::Parser.new

    refute File.exist? @output_file

    # populate final array with seed data
    emails = @emails.dup.uniq.shuffle[0..rand(@emails.length)]
    parser.final_array = emails

    # main test subject
    act = parser.write(@output_file)

    # file exists after calling write
    assert File.exist? @output_file

    # ensure return is File
    assert_kind_of(File, act)

    act = IO.readlines(@output_file).each {|x| x.chomp!}
    assert_kind_of(Array, act)
    refute_empty act
    assert_equal emails, act
  end

  def test_parsing_time
    # get actual time of running full parse
    act_time = Benchmark.realtime do
      parser = ChefSteps::Parser.new(:filename => @test_file)
      parser.parse!
      parser.write(@output_file)
    end

    # max time allowed is one second
    max_time = 1

    # ensure parsing took less than max time
    assert max_time > act_time

    # output exists
    assert File.exist? @output_file
  end
end
