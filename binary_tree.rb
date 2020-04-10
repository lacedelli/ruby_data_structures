module Comparable
	def compare(node)
		if self.data == node.data
			return true
		else
			return false
		end
	end
end

class Node
	include Comparable
	attr_reader :data
	attr_accessor :left_node, :right_node
	def initialize(data)
		@left_node = nil
		@right_node = nil
		@data = data
	end
	
	private
	attr_writer :data
end

class Tree
	attr_reader :root
	def initialize(array)
		@root = build_tree(array)
	end

	def insert(value, node = @root)
		return if value == node.data
		return if node.nil? or value.nil?

		if value < node.data
			if node.left_node.nil?
				node.left_node = Node.new(value)
			else
				insert(value, node.left_node)
			end
		elsif value > node.data
			if node.right_node.nil?
				node.right_node = Node.new(value)
			else
				insert(value, node.right_node)
			end
		end
	end

	def delete(value, node = @root, parent = nil)
		if node.nil?
			puts "node == nil"
			return
		end
		# Traverse the tree
		if value > node.data
			delete(value, node.right_node, node)
		elsif value < node.data
			delete(value, node.left_node, node)
		end

		# Found node with correct data
		if node.data == value

			# If node has no children
			if node.left_node.nil? && node.right_node.nil?
				puts "Parent node #{parent.data} no longer has child #{node.data}"
				if parent.left_node == node
					parent.left_node = nil
				else
					parent.right_node = nil
				end

			# If right node is leaf
			elsif !node.right_node.nil?() &&  node.left_node.nil?()
				if parent.left_node == node
					parent.left_node = node.right_node
				else
					parent.right_node = node.right_node
				end

			# If left node is leaf
			elsif !node.left_node.nil?() && node.right_node.nil?()
				if parent.left_node == node
					parent.left_node = node.left_node
				else
					parent.right_node = node.left_node
				end

			# If both nodes are leaves/branches
			elsif !node.left_node.nil?() && !node.right_node.nil?()
				inorder = self.inorder() 
				next_inorder = inorder.index(value) + 1
				next_node = self.find(inorder[next_inorder])
				# The "algorithm" is extremely simple, a real tree wouldn't keep
				# all its values because some nodes would get lost due to the 
				# method not handling subnodes properly in a tree
				if parent.left_node == node
					next_node.left_node = node.left_node
					parent.left_node = next_node
				else
					next_node.right_node = node.right_node
					parent.righ_node = next_node
				end
			end
		end
	end

	def find(value, node = @root)
		return node if value == node.data
		return if node.nil? or value.nil?

		if value < node.data
				find(value, node.left_node)
		elsif value > node.data
				find(value, node.right_node)
		end
		
	end

	def level_order()
		queue = []
		root = @root
		unless block_given?
			level_order = Array.new()
			level_order.push(root.data)
			queue.push(root.left_node)
			queue.push(root.right_node)

			until queue.empty?
				current_node = queue.first()

				unless current_node.left_node.nil?
					queue.push(current_node.left_node)
				end
				unless current_node.right_node.nil?
					queue.push(current_node.right_node)
				end

				level_order.push(queue.shift().data)
			end

			level_order
		else
			# TODO Devise a better way to make this work to prevent the second yield statement
			level_order = root.data
			queue.push(root.left_node())
			queue.push(root.right_node())

			until queue.empty?
				current_node = queue.first()

				unless current_node.left_node.nil?
					queue.push(current_node.left_node)
				end
				unless current_node.right_node.nil?
					queue.push(current_node.right_node)
				end
			yield level_order
			level_order = queue.shift().data	
			end
			# It's horribly unelegant, I know but I haven't really gotten around to 
			# figure out a way to print the last element of the queue inside the loop
			yield level_order
			nil
		end
	end
	
	def preorder(node = @root, &block)
		unless block_given?
			pre = []
			preorder() {|n|	pre.push(n)}
			pre
		else
			return if node.nil?
			yield node.data
			# visit left subtree
			preorder(node.left_node, &block)
			# visit right subtree
			preorder(node.right_node, &block)
			end
	end

	def inorder(node = @root, &block)
		unless block_given?
			inord = []
			inorder() {|n| inord.push(n)}
			inord
		else
			return if node.nil?
			inorder(node.left_node, &block)
			yield node.data
			inorder(node.right_node, &block)
		end
	end

	def postorder(node = @root, &block)
		unless block_given?
			post = []
			postorder() {|n| post.push(n)}
			post
		else
			return if node.nil?
			postorder(node.left_node, &block)
			postorder(node.right_node, &block)
			yield node.data
		end
	end

	def depth(node = @root)
		return 0 if node.nil?
		l_depth = depth(node.left_node)
		r_depth = depth(node.right_node)
		puts "#{l_depth}"
		l_depth > r_depth ? max_depth = l_depth + 1 : max_depth = r_depth + 1
		max_depth
	end

	def balanced?()
		root = @root
		left = depth(root.left_node)
		right = depth(root.right_node)
		if left == right
			true
		elsif left + 1 == right
			true
		elsif left == right + 1
			true
		else
			false
		end
	end

	def rebalance!()
		level_order = self.level_order
		build_tree(level_order)
	end

	private
	def build_tree(array)
		@root = Node.new(array.sort().slice!(array.length() / 2))

		uniq_array = array.uniq()
		until uniq_array.empty? do
			element = uniq_array.shift()
			self.insert(element)
		end
		@root
	end
end

tree = Tree.new(Array.new(15){rand(1...100)})
puts "#{tree.level_order}"
puts "#{tree.inorder}"
puts "#{tree.postorder}"
unless tree.balanced?
	tree.rebalance!
	puts "Tree rebalanced!"
end
over_hundred = Array.new(10){rand(100...200)}
over_hundred.each {|num| tree.insert(num)}
unless tree.balanced?
	tree.rebalance!
	puts "Tree rebalanced!"
end
puts "#{tree.level_order}"
puts "#{tree.inorder}"
puts "#{tree.postorder}"

