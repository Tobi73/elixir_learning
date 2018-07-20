defmodule Directives do
    @tag :cool
    @tag :not
    def direct(list) do
        alias Main.Nested, as: Nested
        IO.puts is_atom(Nested)
        IO.puts to_string(Nested)
        IO.puts @tag
        Nested.m(list)
    end
end

defmodule Pattern do
    def match(%{:a => 1} = data), do: "Good"
    def match(%{:a => _} = data), do: "Average"
    def match(_), do: "Bad"
end

defmodule ProductModifierImpl do
    @behaviour ProductModifier

    def modify(%Product{} = product) do
        case product.age do
            x when x < 18 -> {:young, product}
            x -> {:old, product}    
        end
    end
end

defmodule ProductModifier do
    @typedoc """
        Status of product
    """
    @type product_age_status :: {atom, Product}

    @callback modify(Product) :: product_age_status

    def modify!(impl, content) do
        case impl.modify(content) do
            {:old, _} -> IO.puts "Too old!"
            _ -> IO.puts "Too young!"    
        end
    end
end


defmodule Product do
    @enforce_keys [:id]
    defstruct [:id,
        :name,
         age: 27
    ]

end

defprotocol Size do
  def size(data)
end

defimpl Size, for: Product do
    def size(%Product{age: age} = product) when age > 30 do
        product.age * (-1)
    end

    def size(%Product{} = product) do
        product.age
    end
end

defimpl Size, for: Any do
  def size(_), do: 0
end

defmodule OtherUser do
#   @derive [Size]
  defstruct [:name, :age]
end

defmodule Main do
    defmodule Nested do
        def m(list) do
            import Enum, only: [map: 2]
            map(list, &(&1*2))
        end
    end
end

defmodule MyException do
    defexception message: "My own exception"
end

defmodule ExceptionRaiser do
    def raise_my_exception do
        raise MyException
    end

    def raise_runtime_exception do
        raise "Runtime exception!!!"
    end

    def rescue_exception(exc_time) do
        try do
            case exc_time do
                :runtime -> raise_runtime_exception()
                :my -> raise_my_exception()
            end
        rescue
            ex in RuntimeError -> 
                IO.puts "Handled!"
                raise ex
            ex in MyException -> ex
        end
    end
end