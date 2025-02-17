module Termclock
	def self.translate(keyword, breakword: nil, b: nil)
		return keyword if LANG == :en
		characters = keyword.grapheme_clusters

		b = breakword if breakword
		breakword = b if b

		upcased = characters.all? { |x| x.ord.between?(65, 90) }
		downcased = upcased ? false : characters.all? { |x| x.ord.between?(97, 122) }
		capitalized = if (upcased || downcased)
			false
		else
			characters[0].ord.between?(65, 90) &&
				characters.drop(1).all? { |x| x.ord.between?(97, 122) }
		end

		camelized = if (upcased || downcased || capitalized)
			false
		else
			keyword.split(?\s.freeze).all? { |x|
				x[0].ord.between?(65, 90) && x.chars.drop(1).all? { |y| y.ord.between?(97, 122) }
			}
		end

		if breakword
			return characters.map { |x|
				tr = TRANSLATIONS[x]

				if !tr
					tr = TRANSLATIONS[x.downcase]
				end

				tr.upcase! if tr && upcased
				tr.downcase! if tr && downcased
				tr.capitalize! if tr && capitalized
				tr.camelize! if tr && camelized

				tr ? tr : x
			}.join
		end

		tr = TRANSLATIONS[keyword]

		if !tr
			tr = TRANSLATIONS[keyword.downcase]

			tr.upcase! if tr && upcased
			tr.downcase! if tr && downcased
			tr.capitalize! if tr && capitalized
			tr.camelize! if tr && camelized
		end

		tr ? tr : keyword
	end

	def self.t!(keyword, breakword: true, b: true)
		return keyword if LANG == :en
		translate(keyword.to_s, breakword: true)
	end
end
