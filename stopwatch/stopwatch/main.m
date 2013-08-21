//
//  main.m
//  stopwatch
//
//  Created by Dan Meltz on 8/21/13.
//  Copyright (c) 2013 Dan Meltz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
