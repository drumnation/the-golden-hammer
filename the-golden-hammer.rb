 begin
  require 'watir'
rescue LoadError
  `gem install watir`
  `gem install chromedriver-helper`
end

$browser = Watir::Browser.new :chrome

def great_artists_steal(lesson_name, class_id, lesson_filename)
  $lesson_name = lesson_name
  $class_id = class_id
  $lesson_filename = lesson_filename

  # scrape usernames to an array
  def scrape_students
    student_lesson_forks_url = "https://github.com/learn-co-students/#{$lesson_name}-#{$class_id}/network/members"
    $browser.goto(student_lesson_forks_url)
    divs = $browser.divs(class: 'repo')
    divs.collect do |div|
      div.text.split(" / ")[0]
    end
  end

  # create file url hash {:student => solution_file_url}
  def lesson_file_urls_hash(scrape_students)
    scrape_students.each_with_object({}) do |student, solution_urls|
      solution_urls[student] = "https://raw.githubusercontent.com/#{student}/#{$lesson_name}-#{$class_id}/master/#{$lesson_filename}"
    end
  end

  urls_hash = lesson_file_urls_hash(scrape_students)

  def great_artists_scrape(urls_hash)
    @answer_array = []

    urls_hash.each do |name, file_url|
      def output_to_array(name, file_url)
        $browser.goto(file_url)
        answer_scrape = $browser.text
        answer_str = <<~HEREDOC
          # #{name.upcase}'s super smart answer™ Dave © 2017
          # #{file_url}

          # -------------------------------------------------------------------------------------------------

          #{answer_scrape}

          # -------------------------------------------------------------------------------------------------
          HEREDOC
        if (name != "learn-co-students") && (answer_scrape != @answer_array.first)
          @answer_array << answer_str
          puts answer_str
        else
        end
      end
      output_to_array(name, file_url)
    end

    urls_hash.each do |name, file_url|
      def output_to_file(file_url)
        @answer_array.shuffle.each do |answer|
          if $lesson_name + ".rb"
            open($lesson_name + ".rb", 'a') {|file|
              file.puts "#{answer}"
            }
          else
            File.write($lesson_name + ".rb", $browser.text)
          end
        end
      end
      output_to_file(file_url)
    end
  end
  print "\e[8;40;101t"
  great_artists_scrape(urls_hash)
end

$typed_lesson = true

def golden_hammer_cli


  def welcome
    puts `clear`
    puts <<~HEREDOC
      ------------------------------------------
      >>> Thou Hath Saught The Golden Hammer <<<
      ------------------------------------------

                                      |`.
           .--------------.___________| |
           |//////////////|___________[ ]
           `--------------'           | |
                                      '-'
      ------------------------------------------
                  EXPAND YOUR VOCAB
      ------------------------------------------
      HEREDOC
    sleep(1)
    puts `clear`
    puts <<~HEREDOC
      ---------------------------------------------
      |          SELECT A FLATIRON CLASS          |
      ---------------------------------------------
      |                                           |
      |  1. Explode centuries of codes    06-16   |
      |  2. Find all the answers to life  07-16   |
      |  3. The search for meaning        09-16   |
      |  4. Bask in the ancient wisdom of 11-16   |
      |  5. Experience the evil genius of 02-17   |
      |  6. Learn from Eyes on the Prys  03-13-17 |
      |  7. All classes                           |
      ---------------------------------------------
      |             Press Q to Quit               |
      ---------------------------------------------
      HEREDOC
    case gets.strip.upcase
    when "1"
      class_id = "0616"
      get_lesson_name_path_run(class_id)
    when "2"
      class_id = "0716"
      get_lesson_name_path_run(class_id)
    when "3"
      class_id = "0916"
      get_lesson_name_path_run(class_id)
    when "4"
      class_id = "1116"
      get_lesson_name_path_run(class_id)
    when "5"
      class_id = "0217"
      get_lesson_name_path_run(class_id)
    when "6"
      class_id = "031317"
      get_lesson_name_path_run(class_id)
    when "7"
      flatiron_cohorts = ["0217", "031317", "1116", "0616", "0716", "0916"]
      flatiron_cohorts.shuffle.each do |cohort|
        get_lesson_name_path_run(cohort)
        $typed_lesson = false
      end
    when "Q"
      exit
    end
  end

  def get_lesson_name_path_run(class_id)
    if $typed_lesson
      puts `clear`
      print "\e[8;20;60t"
      puts "> Copy pasta the lesson name as it appears on GitHub without -classname."
      puts "ex. ruby-objects-has-many-lab-web\n"
      @lesson_name = gets.strip.downcase
      puts ""
      puts "> Enter the relative path to the solution file on GitHub."
      puts "ex. lib/song.rb\n"
      @lesson_filename = gets.strip
    end

    puts `clear`
    puts "@@> Preparing hammer to obliterate your code confusion <@@"
    puts "/"
    sleep (1)
    puts "*"
    sleep(1)
    puts "\\"
    puts "     >>>>>>>>> | LAUNCHING GOLDEN HAMMER - COHORT #{class_id} | <<<<<<<<<<"
    sleep(1)

    great_artists_steal(@lesson_name, class_id, @lesson_filename) # RUNS THE SCRAPER + LOGS OUTPUT

    puts <<~HEREDOC
      ************************    SUPER SMASH!!!!! END COHORT #{class_id}  ******************************

                      For all the goodness check for #{$lesson_filename.split("/")[1]}

      ***************************************************************************************************
      HEREDOC
  end
  welcome
end

golden_hammer_cli
