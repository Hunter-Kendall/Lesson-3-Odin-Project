class Cipher
    
    def encript(str, jumps)
        #split characters and convert to ints
        ascii = str.chars.map{|c| c.ord}
        #add number of jumps to each int
        text = ascii.map{|c| 
            if c >= 65 && c <=90
                if c + jumps > 90
                    cut = 90 - c
                    new_jump = jumps - cut
                    64 + new_jump
                else
                    c + jumps
                end
                
            elsif c >= 97 && c<=122
                if c + jumps > 122
                    cut = 122 - c
                    new_jump = jumps - cut
                    96 + new_jump
                else
                    c + jumps
                end
            else
                c
            end
        }
        #converts ints to sting
        text.map{|c| c.chr}.join
    end
end