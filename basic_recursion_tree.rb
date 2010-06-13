# This is a basic example of recursion trees or fractle tree
# Simpley this will split the branch at a given angle at the end of each branch

require 'rubygems'
require 'gosu'

class Range
  def rand
    self.to_a.sample
  end
end

module RecursionTree
  WIDTH      = 800
  HEIGHT     = 600
  FULLSCREEN = false

  class Tree
    ANGLE = (20..90)
    SHRINK = (2..6)
    SPLIT = (5..12)
    BRANCH_LENGTH = (75..300)

    BOTTOM_MARGIN = 10

    def initialize
      @shrink = SHRINK.rand / 10.0
      @max_splits = SPLIT.rand         # how many times the branches have split
      @degree_shrink = ANGLE.rand
      @branches = []
      x = WIDTH / 2
      @branches << [ [[x, HEIGHT - BOTTOM_MARGIN], [x, HEIGHT - BRANCH_LENGTH.rand]] ] # First Branch
    end

    def update
      last_section = @branches.last
      new_section  = []

      if @branches.length < @max_splits
        last_section.each do |b|
          new_section << get_branch(b, 1)
          new_section << get_branch(b, -1)
        end

        @branches << new_section
      end
    end

    def branch_lines
      @branches.flatten(1)
    end

    def get_branch section, side
      x1, y1 = section[0]
      x2, y2 = section[1]
      length = (Gosu::distance(x1, y1, x2, y2) * @shrink).to_i
      branch_angle = (Gosu::angle(x1, y1, x2, y2)).to_i + @degree_shrink * side
      branch_x = x2 + Gosu::offset_x(branch_angle, length)
      branch_y = y2 + Gosu::offset_y(branch_angle, length)
      [[x2, y2], [branch_x.to_i, branch_y.to_i]]
    end
  end

  class Game < Gosu::Window
    TREE_COLOR = Gosu.black
    BG_COLOR_1 = Gosu.white
    BG_COLOR_2 = Gosu.gray

    def initialize
      super(WIDTH, HEIGHT, FULLSCREEN)
      self.caption = "Basic Recursion Tree"
      # Gosu and Moot Logos
      @mootlogo = Gosu::Image.new(self, "media/moot.png", false)
      @gosulogo = Gosu::Image.new(self, "media/gosu_logo.png", false)
      @text = Gosu::Font.new(self, 'media/bitlow.ttf', 10)
      generate_tree
    end

    def update
      @tree.update
    end

    def draw
      draw_quad(0, 0, BG_COLOR_1, WIDTH, 0, BG_COLOR_1,
                0, HEIGHT, BG_COLOR_2, WIDTH, HEIGHT, BG_COLOR_2)

      draw_tree

      # Drawing the Logos
      @gosulogo.draw(10, HEIGHT - 43, 1)
      @mootlogo.draw(WIDTH - 83, HEIGHT - 43, 1)
      @text.draw("PRESS SPACE TO GENERATE A NEW TREE", 10, 10, 1, 1.5, 1.5, 0xFF000000)
    end

    def draw_tree
      @tree.branch_lines.each do |(x1, y1), (x2, y2)|
        draw_line(x1, y1, TREE_COLOR, x2, y2, TREE_COLOR)
      end
    end

    def button_down(id)
      close         if id == Gosu::KbEscape
      generate_tree if id == Gosu::KbSpace
    end

    def generate_tree
      @tree = Tree.new
    end
  end
end

RecursionTree::Game.new.show