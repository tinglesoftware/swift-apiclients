import Foundation

extension String{
    /**
    * Appends a quoted-string to a StringBuilder.
    * RFC 2388 is rather vague about how one should escape special characters in form-data
    * parameters, and as it turns out Firefox and Chrome actually do rather different things, and
    * both say in their comments that they're not really sure what the right approach is. We go
    * with Chrome's behavior (which also experimentally seems to match what IE does), but if you
    * actually want to have a good chance of things working, please avoid double-quotes, newlines,
    * percent signs, and the like in your field names.
     */
    mutating func appendQuotedString(key:String){
        append("\"")
        for i in 0..<key.count{
            let ch = Array(key)[i]
            switch ch {
            case "\n": append("%0A")
            case "\r": append("%0D")
            case "\"": append("%22")
            default: append(ch)
            }
        }
        append("\"")
    }
}
