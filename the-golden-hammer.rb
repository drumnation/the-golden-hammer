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
        answer_str = %Q(
# #{name.upcase}'s super smart answer™ Dave © 2017
# #{file_url}

# -------------------------------------------------------------------------------------------------

#{answer_scrape}

# -------------------------------------------------------------------------------------------------)
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
        @answer_array.each do |answer|
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

def golden_hammer_cli

  def greetings
    puts "-----------------------------------------------------------"
    puts "               GREETINGS FELLOW FLATIRONERS!               "
    puts "-----------------------------------------------------------"
  end

  def welcome
    welcome_message = %q(
The gifted entrepreneur Steve Jobs made some controversial
comments about innovation during his career. He expressed
strong agreement with the following aphorism which he
ascribed to the famous painter Pablo Picasso:

'Good artists copy; great artists steal.'

I would happen to agree. With a B.A. in Music Composition, I
learned all about transforming any theme into something new.
Doing this requires many techniques for manipulating music
in a controlled manner, allowing you to achieve the exact
aesthetic you hear in your mind. A score is a program that
runs live humans in synchronization instead of a computer.

I spent hours in the music library poring over orchestral
scores while listening to their recordings. It taught me to
connect what things sound like with what things look like on
the page. It also gave me the opportunity to collect a grab
bag of techniques that I liked a lot and could later use in
my own music.

The ultimate secret of master makers is that nobody is
original. The greatest artists copy as many of their idols
as they can because they absolutely love them and their
resulting products often become beautiful diverse blends of
others' fresh and original ideas, neatly curated by the
artist.

Every answer to a Flatiron question becomes a tool we will
use to make our future programs better so why not learn ALL
the answers? In the spirit of our recent reading assignment
'Hackers and Painters' I want to give this tool to
everybody so we can better learn from each other.

When I'm stumped I fire up the Golden Hammer make a list of
the 5 most cleverly diverse solutions and try to refactor
them into an über answer.

I then take screenshots of my über answer and the selected 5
and put them on the back of an Anki digital flashcard (will
also explain that on my blog soon). I look up the docs for,
and screenshot, any syntax or terms used that I didn't
understand.

I wrote this program while I was doing my prework and
decided to clean it up and make it easy for other people to
use. I updated it with this menu stuff at the end of my first
week.  I credit this to the smarts of the 0217 class because
I've been all over their answers and they have some really
smart people.

My percussion instructor taught us to never practice
mistakes. Always slow the metronome down until you can play
it perfect or you're just teaching yourself to play it
wrong.  Without our community of ideas you could be
practicing the longest way to solve your problems exercise
after exercise and never know it.

The real truth is it's not stealing. It's just a much more
effective way to learn. Since it's such a pain in the butt
clicking so many links to get to the answers on GitHub, not
being sure if the answer you clicked is complete, I hope
this bot helps everyone learn more efficiently.

Feel free to steal this code and make your own bot! It
should have automatically installed Watir the Ruby library
for the testing suite Selenium as well as Chromedriver.

Ask me for help anytime! Thanks guys! -Dave Mieloch

---- Press C to Continue or Q to  ---)
    puts `clear`
    print "\e[8;68;61t" # resizes window to 55x80
    puts welcome_message
    case gets.strip.upcase
    when "C"
      puts `clear`
      menu
    when "Q"
      return
    else
      puts `clear`
      puts '\n*** Invalid Input ***\n'
      puts 'Press C to Continue or Q to Quit'
      sleep(2)
      puts `clear`
      welcome
    end
  end

  def menu
    welcome_hammer_query = %Q(
------------------------------------------
>>> Thou Hath Saught The Golden Hammer <<<
------------------------------------------

                                |`.
     .--------------.___________| |
     |//////////////|___________[ ]
     `--------------'           | |
                                '-'

Have you sufficiently frustrated yourself
     before seeking the mighty hammer?
------------------------------------------
              Enter Y or N
------------------------------------------)
    print "\e[8;20;42t"
    puts welcome_hammer_query

    case gets.strip.upcase
    when "Y"
      puts "I must now perform the ceremony of light."
      puts "/"
      sleep (1)
      puts "*"
      sleep(1)
      puts "/"
      puts "just kidding...\n"
      sleep(1)
      puts `clear`
      class_menu = %(
------------------------------------------
|         SELECT A FLATIRON CLASS        |
------------------------------------------
1. Bask in the ancient wisdom of 11-16
2. Experience the evil genius of 02-17
3. Learn from the borg hive mind 03-13-17
------------------------------------------
             Press Q to Quit
------------------------------------------)
      puts class_menu
      case gets.strip.upcase
      when "1"
        class_id = "1116"
        get_lesson_name_path_run(class_id)
      when "2"
        class_id = "0217"
        get_lesson_name_path_run(class_id)
      when "3"
        class_id = "031317"
        get_lesson_name_path_run(class_id)
      when "Q"
        return
      else
        puts `clear`
        invalid_input = %(
***********    Invalid Input    **********

------------------------------------------
|     PLEASE SELECT A FLATIRON CLASS     |
------------------------------------------
1. Bask in the ancient wisdom of 11-16
2. Experience the evil genius of 02-17
3. Learn from the borg hive mind 03-13-17
------------------------------------------
             Press Q to Quit
------------------------------------------
)
        puts invalid_input
      end
    when "N"
      puts "Spin your wheels some more and come back for the mojo only if you need it."
      return
    else
      puts `clear`
      invalid_input_y_n = %(
***********   Invalid Input    **********

Have you sufficiently frustrated yourself
     before seeking the mighty hammer?
------------------------------------------
              Enter Y or N
------------------------------------------)
      puts invalid_input_y_n
    end
  end

  def get_lesson_name_path_run(class_id)
    puts `clear`
    print "\e[8;20;60t"
    puts "> Copy pasta the lesson name as it appears on GitHub."
    puts "ex. ruby-objects-has-many-lab-web\n"
    lesson_name = gets.strip.downcase
    puts ""
    puts "> Enter the relative path to the solution file on GitHub."
    puts "ex. lib/song.rb\n"
    lesson_filename = gets.strip.downcase

    puts `clear`
    puts "@@> Preparing hammer to obliterate your code confusion <@@"
    puts "/"
    sleep (1)
    puts "*"
    sleep(1)
    puts "\\"
    puts "     >>>>>>>>> | LAUNCHING GOLDEN HAMMER | <<<<<<<<<<"
    sleep(1)

    great_artists_steal(lesson_name, class_id, lesson_filename)

    puts "**************************************    SUPER SMASH!!!!!   **************************************"
    puts "                         For all the goodness check for #{$lesson_filename.split("/")[1]}"
    puts "                         in the same directory you ran The Golden Hammer."
    puts "***************************************************************************************************"
  end
  greetings
  sleep(2)
  puts `clear`
  welcome
end

golden_hammer_cli
