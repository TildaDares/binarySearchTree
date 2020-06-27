require_relative 'node'
class Tree
    attr_accessor :root
    def initialize(array)
        @root = build_tree(array)
    end

    def insert(node = @root, value)
        return false if node.data == value
        if node.data > value
            if node.left_node
                insert(node.left_node, value)
            else
                node.left_node = Node.new(value)
            end
        else
            if node.right_node
                insert(node.right_node, value)
            else
                node.right_node = Node.new(value)
            end
        end
    end

    def delete(node = @root, value)
        if node == nil
            return node
        elsif node.data > value
            node.left_node = delete(node.left_node, value)
        elsif node.data < value
            node.right_node = delete(node.right_node, value) 
        else
            if node.left_node == nil && node.right_node == nil #no children
                node = nil
            elsif node.right_node == nil #no right child
                node = node.left_node
            elsif node.left_node == nil #no left child
                node = node.right_node
            else # has two children
                array = inorder(node.right_node)
                node.data = array.shift
                node.right_node = delete(node.right_node, node.data)
            end
        end
        return node
    end

    def find(node = @root, value)
        return false if node.nil?
        return node.data if node.data == value
        if node.data > value
            find(node.left_node, value)
        else
            find(node.right_node, value)
        end
    end

    def inorder(node = @root, array = [], &block)
        return if node.nil?
        inorder(node.left_node, array, &block)
        block_given? ? yield(node) : array << node.data
        inorder(node.right_node, array, &block)
        array
    end

    def postorder(node = @root, array = [], &block)
        return if node.nil?
        postorder(node.left_node, array, &block)
        postorder(node.right_node, array, &block)
        block_given? ? yield(node) : array << node.data
        array
    end

    def preorder(node = @root, array = [], &block)
        return if node.nil?
        block_given? ? yield(node) : array << node.data
        preorder(node.left_node, array, &block)
        preorder(node.right_node, array, &block)
        array
    end

    def level_order(node = @root)
        queue = []
        output = []
        queue << node
        until empty_nodes(queue)
            current = queue.shift
            unless current == nil
                if current.left_node && current.right_node
                    queue << current.left_node << current.right_node 
                elsif current.left_node
                    queue << current.left_node
                elsif current.right_node
                    queue << current.right_node
                else
                    queue << nil
                end
                block_given? ? yield(current) : output << current.data
            else
                block_given? ? yield(current) : output << 'nil'
                queue << nil
                queue << nil
            end
        end
        output
    end

    def depth(node = @root)
       return -1 if node == nil
       return [depth(node.left_node), depth(node.right_node)].max + 1
    end

    def balanced?(node = @root)
        return 0 if node == nil
        left_depth = depth(node.left_node)
        right_depth = depth(node.right_node)
        return false if left_depth == nil || right_depth == nil
        return false if (left_depth - right_depth).abs > 1
        true
    end

    def rebalance
        @root = build_tree(inorder)
    end

    private
    def build_tree(array)
        return if array.empty?
        if array.length < 2
            return Node.new(array.first)
        end
        unique_array = array.sort.uniq
        mid = (unique_array.length/2).round
        root = Node.new(unique_array[mid])
        root.left_node = build_tree(unique_array.take(mid))
        root.right_node = build_tree(unique_array.drop(mid+1))
        root
    end

    def empty_nodes(queue)
        is_empty = true
        queue.each{|e| is_empty = false unless e == nil}
        is_empty
    end
end

puts 'Random array elements'
tree = Tree.new(Array.new(15) { rand(1..100) })
puts 'Check if tree is balanced'
puts tree.balanced?
puts 'Level order'
p tree.level_order
puts "\n"
puts 'Pre-order'
p tree.preorder
puts "\n"
puts 'Inorder'
p tree.inorder
puts "\n"
puts 'Post-order'
p tree.postorder
puts "\n"
puts 'Add more elements'
5.times { tree.insert(rand(101..200)) }
puts 'Level order'
p tree.level_order
puts "\n"
puts 'Check if tree is balanced'
puts tree.balanced?
puts 'Rebalance tree'
tree.rebalance
puts 'Check if tree is balanced'
puts tree.balanced?
puts 'Level order'
p tree.level_order
puts "\n"
puts 'Pre-order'
p tree.preorder
puts "\n"
puts 'Inorder'
p tree.inorder
puts "\n"
puts 'Post-order'
p tree.postorder
puts "\n"
tree.level_order do |v| 
    if v == nil
    else
        puts v.data 
    end
end
tree.preorder { |v| puts v.data }
tree.inorder { |v| p v.data }
tree.postorder { |v| p v.data }