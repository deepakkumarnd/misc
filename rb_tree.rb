#!/usr/bin/env ruby

require 'pry'

module RB
  class RBnode
    RED   = "red"
    BLACK = "black"

    attr_accessor :parent, :left, :right, :color, :data, :key

    def initialize(key, data, left, right, parent, color = RED)
      @parent = parent
      @left   = left
      @right  = right
      @data   = data
      @key    = key
      @color  = color
    end
  end

  class RBtree
    def initialize
      # @nilnode is a special node which is always empty and black in color.
      # @nilnode's right child will point to root node of the tree
      @nilnode = RBnode.new(nil, nil, nil, nil, nil, RBnode::BLACK)
      @root    = nil
    end

    def set_root_node(node)
      #   @nilnode
      #  / \
      # /   \
      # nil  @root

      @root           = node
      @root.parent    = @nilnode
      @root.color     = RBnode::BLACK
      @nilnode.right  = @root
      @root
    end

    def create_new_node(key, data)
      RBnode.new(key, data, @nilnode, @nilnode, @nilnode, RBnode::RED)
    end

    def locate_insert_position(new_node)
      tmp = curr = @root

      while(curr != @nilnode) do
        tmp = curr
        curr = (new_node.key < curr.key) ? curr.left : curr.right
      end

      tmp
    end

    def insert(key, data = nil)
      new_node = create_new_node(key, data)
      # if the tree is empty then just set the root node
      set_root_node(new_node); return if @root.nil?

      old = locate_insert_position(new_node)

      new_node.parent = old

      if new_node.key < old.key
        old.left  = new_node
      else
        old.right = new_node
      end

      insert_fixup(new_node)
    end

    def grandparent(z)
      z.parent.parent
    end

    def uncle(z)
      (z.parent == grandparent(z).left) ? grandparent(z).right : grandparent(z).left
    end

    def insert_fixup(z)
      while((z != @root) && (z.parent.color == RBnode::RED)) do

        y = uncle(z)

        if z.parent == grandparent(z).left

          if y.color == RBnode::RED
            y.color              = RBnode::BLACK
            z.parent.color       = RBnode::BLACK
            grandparent(z).color = RBnode::RED
            z = grandparent(z)

          else

            if z == z.parent.right
              z = z.parent
              left_rotate(z.parent)
            end

            z.parent.color       = RBnode::BLACK
            grandparent(z).color = RBnode::RED
            right_rotate(grandparent(z))
          end
        else

          if y.color == RBnode::RED
            y.color              = RBnode::BLACK
            z.parent.color       = RBnode::BLACK
            grandparent(z).color = RBnode::RED
            z = grandparent(z)

          else

            if z == z.parent.left
              z = z.parent
              right_rotate(z.parent)
            end

            z.parent.color       = RBnode::BLACK
            grandparent(z).color = RBnode::RED
            left_rotate(grandparent(z))
          end
        end
      end

      @root.color = RBnode::BLACK
    end

    def delete(key)
    end

    def keys
      traverse_inorder(@root) do |node|
        puts "n#{node.key} l#{node.left.key} r#{node.right.key} #{node.color}"
      end
      puts ""
    end

    def traverse_inorder(node, &block)
      return if node.nil? || node == @nilnode
      yield node if block
      traverse_inorder(node.left, &block)
      traverse_inorder(node.right, &block)
    end

    ##########################################################
    #                    Tree Rotations                      #
    #                    --------------                      #
    #       |                                        |       #
    #       |                                        |       #
    #       x                                        y       #
    #      / \                                      / \      #
    #     /   \          left_rotate(x) ->         /   \     #
    #    a     y         <- right_rotate(y)       x     c    #
    #         / \                                / \         #
    #        /   \                              /   \        #
    #       b     c                            a     b       #
    ##########################################################

    def left_rotate(x)
      p        = x.parent
      y        = x.right
      b        = y.left
      y.left   = x
      x.parent = y
      y.parent = p
      x.right  = b
      b.parent = x
      (p.right == x) ? (p.right = y) : (p.left = y)

      @root = y if x == @root
    end

    def right_rotate(y)
      p        = y.parent
      x        = y.left
      b        = x.right
      x.right  = y
      y.parent = x
      x.parent = p
      y.left   = b
      b.parent = y
      (p.right == y) ? (p.right = x) : (p.left = x)
      @root = x if y == @root
    end
  end
end

tree = RB::RBtree.new

loop do
  puts "1. Insert into redblack tree"
  puts "2. Delete from redblack tree"
  puts "3. View tree"
  puts "4. Exit"
  input = gets.strip.to_i

  case input
  when 1 then
    puts "Key"
    key = gets.strip
    puts "Value"
    value = gets.strip
    tree.insert(key, value)
  when 2 then
    puts "Yet to be implemented"
  when 3 then
    tree.keys
  when 4 then exit
  end
end
