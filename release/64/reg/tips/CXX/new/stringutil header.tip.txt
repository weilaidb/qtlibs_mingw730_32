/***
 * Excerpted from "Modern C++ Programming with Test-Driven Development",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/lotdd for more book information.
***/
#ifndef StringUtil_h
#define StringUtil_h

#include <string>

namespace stringutil {
   std::string head(const std::string& word);
   std::string tail(const std::string& word);
   std::string zeroPad(const std::string& text, unsigned int toLength);
   std::string upperFront(const std::string& string);
}

#endif
