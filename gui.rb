#!/usr/bin/env ruby
#
# This file is gererated by ruby-glade-create-template 1.1.4.
#
require 'libglade2'
require 'gtk2'

class OcamlsearchrGlade
  include GetText

  attr :glade
  
  def initialize(path_or_data, root = nil, domain = nil, localedir = nil, flag = GladeXML::FILE)
    bindtextdomain(domain, localedir, nil, "UTF-8")
    @glade = GladeXML.new(path_or_data, root, domain, localedir, flag) {|handler| method(handler)}
    @fileselector = @glade.get_widget("filechooser1")
    @listview = @glade.get_widget("treeview1")
    [_("Adress"), _("Hexadecimal"), _("Text")].each_with_index { |name, i|
      column = Gtk::TreeViewColumn.new(name, Gtk::CellRendererText.new, :text => i)
      @listview.append_column(column)
    }
    @store = Gtk::ListStore.new(String, String, String)
    @listview.model = @store
  end
  
  def on_open1_activate(widget)
    @fileselector.show
  end
  def on_quit1_activate(widget)
    Gtk.main_quit
  end
  def gtk_main_quit(widget, arg0)
    Gtk.main_quit
  end
  def on_startbutton_pressed(widget)
    iter = @store.append
    iter[0] = "Joe"
    iter[1] = "Average"
    iter[2] = "1970"
  end
  def on_A_propos1_activate(widget)
    puts "on_A_propos1_activate() is not implemented yet."
  end
  def on_button5_pressed(widget)
    puts "on_button5_pressed() is not implemented yet."
  end
end

# Main program
if __FILE__ == $0
  # Set values as your own application. 
  PROG_PATH = "ocamlsearchr.glade"
  PROG_NAME = "YOUR_APPLICATION_NAME"
  OcamlsearchrGlade.new(PROG_PATH, nil, PROG_NAME)
  Gtk.main
end
