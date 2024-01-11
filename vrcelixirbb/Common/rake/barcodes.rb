# ============
# = Barcodes =
# ============

## no longer needed. Done via PIP
                     
# desc "Create barcodes in eps and pdf formats" 
# task :barcodes => [ "#{NAME}_EAN.pdf", "#{NAME}_UPC.pdf" ]
# desc "Create the EAN"
# file "#{NAME}_EAN.eps" do
#   sh "python ../PPStuff/util/bin/bookland.py -s0.66 #{ISBN} 5#{PRICE} >#{NAME}_EAN.eps"  do
#     rm "#{NAME}_EAN.eps"
#   end
# end  

# desc "Create the UPC"
# file "#{NAME}_UPC.eps" do
#   sh "barcode -e UPC -b #{UPC} -E -u in -g 1.5x0.75+0+0 > #{NAME}_UPC.eps" do
#     rm "#{NAME}_UPC.eps"
#   end
# end 

# rule '.pdf' => '.eps' do |t|
#   sh "#{PS2PDF} #{PDFPARAM} #{t.source}" do
#     rm t.name
#   end
# end
