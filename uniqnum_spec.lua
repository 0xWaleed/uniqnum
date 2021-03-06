---
--- Created By 0xWaleed <https://github.com/0xWaleed>
--- DateTime: 14/02/2022 8:45 AM
---

local function hard_require(module)
    local r                = require(module)
    package.loaded[module] = nil
    return r
end

describe('uniqnum', function()
    before_each(function()
        hard_require('uniqnum')
    end)

    describe('uniqnum_random', function()
        it('exist', function()
            assert.is_function(uniqnum_random)
        end)

        it('returns a number', function()
            local n = uniqnum_random()
            assert.is_number(n)
        end)

        it('should not return the same number', function()
            local n1 = uniqnum_random()
            local n2 = uniqnum_random()
            assert.is_not_same(n1, n2)
        end)

        it('should able to set the minimum number', function()
            local min  = 1
            local max  = 5
            local uniq = UniqNum.new(min, max)
            for _ = 1, max do
                assert.is_true(uniq:next() >= min)
            end
        end)

        it('should able to set the maximum number', function()
            local min  = 1
            local max  = 5
            local uniq = UniqNum.new(min, max)
            for _ = 1, max do
                assert.is_true(uniq:next() <= max)
            end
        end)

        it('should able to generate all possible numbers', function()
            local min  = 0
            local max  = 3
            local uniq = UniqNum.new(min, max)
            local all  = {}
            while max >= min do
                local n          = uniq:next()
                all[tostring(n)] = n
                max              = max - 1
            end
            assert.not_nil(all['0'])
            assert.not_nil(all['1'])
            assert.not_nil(all['2'])
            assert.not_nil(all['3'])
        end)

        it('should able to generate all possible numbers with min of greater than 0', function()
            local min  = 1
            local max  = 3
            local uniq = UniqNum.new(min, max)
            local all  = {}
            while max >= min do
                local n          = uniq:next()
                all[tostring(n)] = n
                max              = max - 1
            end
            assert.not_nil(all['1'])
            assert.not_nil(all['2'])
            assert.not_nil(all['3'])
        end)

        it('should throw error when reach the maximum', function()
            local min  = 1
            local max  = 3
            local uniq = UniqNum.new(min, max)
            local all  = {}
            while max >= min do
                local n          = uniq:next()
                all[tostring(n)] = n
                max              = max - 1
            end
            assert.was_error(function()
                uniq:next()
            end)
        end)

        it('should able to remove an item', function()
            local min  = 1
            local max  = 2
            local uniq = UniqNum.new(min, max)
            uniq:next()
            local i = uniq:next()
            uniq:remove(i)
            assert.was_no_error(function()
                uniq:next()
            end)
            assert.is_equal(2, uniq:itemsCount())
        end)

        it('should able to clear all items', function()
            local min  = 1
            local max  = 2
            local uniq = UniqNum.new(min, max)
            uniq:next()
            uniq:next()
            uniq:clear()
            assert.was_no_error(function()
                uniq:next()
                uniq:next()
            end)
            assert.is_equal(2, uniq:itemsCount())
        end)

        it('should get random element if we give an array', function()
            local uniq = UniqNum.new({ 'a', 'b', 'c' })
            local all  = {}
            for _ = 1, 3 do
                local n = uniq:next()
                all[n]  = n
            end
            assert.not_nil(all['a'])
            assert.not_nil(all['b'])
            assert.not_nil(all['c'])
        end)

        it('should throw when no more element exist', function()
            local uniq = UniqNum.new({ 'a', 'b', 'c' })
            local all  = {}
            for _ = 1, 3 do
                local n = uniq:next()
                all[n]  = n
            end
            assert.not_nil(all['a'])
            assert.not_nil(all['b'])
            assert.not_nil(all['c'])
            assert.has_error(function()
                uniq:next()
            end)

            assert.has_error(function()
                UniqNum.new({}):next()
            end)
        end)
    end)

    describe('protected mode', function()
        it('exist', function()
            local uniq = UniqNum.new({ 'a', 'b', 'c' })
            assert(uniq.protectedNext)
        end)

        it('should not throw for elements', function()
            local uniqElement = UniqNum.new({ 'a', 'b', 'c' })
            local all         = {}
            for _ = 1, 3 do
                local n = uniqElement:protectedNext()
                all[n]  = n
            end
            assert.not_nil(all['a'])
            assert.not_nil(all['b'])
            assert.not_nil(all['c'])
            assert.is_nil(uniqElement:protectedNext())
        end)

        it('should not throw for numbers', function()
            local uniqElement = UniqNum.new(1, 3)
            local all         = {}
            for _ = 1, 3 do
                local n          = uniqElement:protectedNext()
                all[tostring(n)] = n
            end
            assert.not_nil(all['1'])
            assert.not_nil(all['2'])
            assert.not_nil(all['3'])
            assert.is_nil(uniqElement:protectedNext())
        end)
    end)
end)
