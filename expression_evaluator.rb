PRECDENCE = {
  '(' => 0,
  ')' => 0,
  '+' => 1,
  '-' => 1,
  '*' => 2,
  '/' => 2
}

class Expression
  def initialize(expr)
    @expr = expr.gsub(/\s/, '')
    @operators = []
    @values    = []
    @pos = 0
  end

  def evaluate
    tok = next_token

    while tok
      case tok
      when '('
        @operators.push '('
      when /[[:digit:]]/
        num = extract_value
        @values.push(num)
      when /(\+|-|\*|\/)/
        while (!@operators.empty?) && (precedence(@operators.last) >= precedence(tok))
          res = calc
          @values.push(res)
        end
        @operators.push tok
      when ')'
        while @operators.last != '('
          res = calc
          @values.push(res)
        end

        @operators.pop
      else
        raise 'Invalid expression'
      end

      tok = next_token
    end

    while !@operators.empty?
      operator = @operators.pop
      calc
    end
  end

  def extract_value
    num = ''
    @pos = @pos - 1
    tok = next_token
    while tok =~ /[[:digit:]]/
      num << tok
      tok = next_token
    end
    @pos = @pos - 1

    num.to_i
  end

  def next_token
    tok = @expr[@pos]
    @pos += 1
    tok
  end

  def calc
    operator = @operators.pop
    operand1 = @values.pop
    operand2 = @values.pop

    case operator
    when '+'
      operand2 + operand1
    when '-'
      operand2 - operand1
    when '*'
      operand2 * operand1
    when '/'
      operand2 / operand1
    else
      raise 'Invalid operator'
    end
  end

  def precedence(c)
    PRECDENCE[c]
  end

  def result
    @values.last
  end
end


# NOTE: The input should be surrounded by brackets
expr = '((3+(5*2)-1)/12)'

e = Expression.new(expr)
e.evaluate
puts e.result
