module.exports= ($xonom)->
    $xonom.object do
      * \$h
      * genid: ->
            s4 = -> Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
            s4! + s4! + s4! + s4! + s4! + s4! + s4! + s4!
        genpass: -> 
            chars = \ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz
            string_length = 8
            randomstring = ''
            charCount = 0
            numCount = 0
            i= 0
            while i < string_length
                i++
                if (Math.floor(Math.random() * 2) == 0) and numCount < 3 or charCount >= 5
                    rnum = Math.floor Math.random! * 10
                    randomstring += rnum
                    numCount += 1
                else 
                    rnum = Math.floor Math.random! * chars.length
                    randomstring += chars.substring rnum,rnum + 1
                    charCount += 1
            randomstring