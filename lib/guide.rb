require 'resturant'
require 'support/string_extend'
class Guide

	class Config
		@@actions = ['list', 'add', 'find', 'quit']

		def self.actions; @@actions; end
	end

	def initialize(path)

		Resturant.filepath  = path

		if Resturant.file_usable?
			puts 'Found resturant file'
		elsif Resturant.create_file
			puts 'created resturant file.'
		end



	end

	def launch!
		introducation

		result = nil

		until result == :quit

			
			action, args = get_action
			result = do_action(action, args)
		end

		conclustion
	end

	def get_action

		action = nil
		until Guide::Config.actions.include?(action)
			puts 'Actions : ' + Guide::Config.actions.join(', ') if action
			print '>'
			user_response = gets.chomp
			args = user_response.downcase.strip.split(' ')
			action = args.shift
		end
		return action, args
	end

	def do_action(action, args)
		case action

			when 'list'
				list(args)
			when 'find'
				keyword = args.shift
				find(keyword)
			when 'add'
				add
			when 'quit'
				return :quit
			else
				puts 'I don\'t  understand that command'
				
		end			
	end



	def list(args=[])

		sort_order = args.shift
		sort_order = args.shift if sort_order == 'by'

		sort_order = "name" unless ['name', 'cuisine', 'price'].include?(sort_order)
			
					output_action_header('Listin resturants')

					resturants = Resturant.saved_resturants

					resturants.sort! do |r1, r2|
						case sort_order
						when 'name'
							r1.name.downcase <=> r2.name.downcase
						when 'cuisine'
							r1.cuisine.downcase <=> r2.cuisine.downcase
						when 'price'
							r1.price.to_i <=> r2.price.to_i
						end
					end
					output_resturant_table(resturants)
					puts "\n\n List by #{sort_order}"
	end


	def find(keyword)
		output_action_header('Finding resturants');

		if keyword
			resturants = Resturant.saved_resturants
			found = resturants.select do |rest|
				rest.name.downcase.include?(keyword.downcase) ||
				rest.cuisine.downcase.include?(keyword.downcase) ||
				rest.price.to_i <= keyword.to_i
			end
			output_resturant_table(found)
		else
			puts "\n empty!\n"
		end
	end

	def output_resturant_table(resturants=[])
		print " " + "Name".ljust(30)
		print " " + "Cuisine".ljust(20) 
		print " " + "price".rjust(6) + "\n"
		puts "-" * 60

		resturants.each do |rest|
			line = " " << rest.name.titleize.ljust(30)
			line << " " + rest.cuisine.titleize.ljust(20)
			line << " " + rest.formatted_price.rjust(6)
			puts line
		end
		puts "No listing found" if resturants.empty?
		puts "-" * 60
	end

	def output_action_header(text)
		puts "\n#{text.upcase.center(60)}\n\n"
	end

	def add
		output_action_header('Add a resturant')

		resutrant = Resturant.build_using_questions

		if resutrant.save
			puts "\nResturant added \n\n"
		else
			puts "Save Error: Resturant not added\n\n"
		end


	end

	def introducation
		puts "\n\n<<<<<< Welcome to the Food Finder >>>>>>\n\n"
	end


	def conclustion
		puts "\n\n<<<< GoodBye And Bon Appetit ! >>>>"
	end

end