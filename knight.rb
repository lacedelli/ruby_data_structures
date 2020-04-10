class Board
	attr_reader :board
	def initialize()
		# Not sure if there's a way to initialize a global variable that can be initialized
		# here, instead of generating a new array each time valid_move? is called
	end

	def self.valid_move?(coordinates)
		board = []
		8.times do |row|
			8.times do |column|
				board << [row, column]
			end
		end

		if board.include?(coordinates)
			true
		else
			false
		end
	end

end

class Knight
	attr_reader :position, :range, :moves_coordinates, :parent
	def initialize(coordinates, parent = nil)
		@position = coordinates
		@range = []
		@parent = parent
		@move_coordinates = [[-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], 
											   [-1, -2], [-2, -1], [-2, 1]]
	end

	def self.moves(start, finish)
		origin = Knight.new(start)
		origin.make_moves()
		current = origin
		queue = []
		stack = []
		queue.push(origin)
		pointer = 0
		until current.position == finish
			current.range.each do |move|
				queue.push(move)
			end
			pointer += 1
			current = queue[pointer]
			current.make_moves()
			actual = current
			if current.position == finish
				until actual == nil
					stack.unshift(actual.position)
					actual = actual.parent
				end
			end
		end
		puts "Path found! it takes #{stack.length} moves."
		stack.each do |step|
			puts "#{step}"
		end
	end

	def make_moves()
		# For each of the move coordinates, check with board if it's a legal move
		@move_coordinates.each do |move|
			new_coordinates = [@position[0] + move[0], @position[1] + move[1]]
			if Board.valid_move?(new_coordinates)
				@range << Knight.new(new_coordinates, self)
			end
		end
	end

	private
	attr_writer :range, :parent

end

Knight.moves([3, 3], [4, 3])
