# require File.join(File.dirname(__FILE__), 'gilded_rose')
require_relative '../gilded_rose'

describe GildedRose do
  before(:each) do
    GildedRose.new(items).update_quality
  end

  describe '#update_quality' do
    context 'when item name is foo' do
      let(:items) { [Item.new('foo', 2, 2)] }
      it 'does not change the name' do
        expect(items[0].name).to eq 'foo'
      end

      it 'should be string' do
        expect(items[0].to_s).to be_a(String)
        expect(items[0].to_s).to eq "foo, 1, 1"
      end

      it 'decreases SellIn value' do
        expect(items[0].sell_in).to eq 1
      end

      it 'decreases Quality value' do
        expect(items[0].quality).to eq 1
      end

      context 'when Quality value is 0' do
        let(:items) { [Item.new('foo', 1, 0)] }
        it 'does not decrease Quality value below 0' do
          expect(items[0].quality).to eq 0
        end
      end

      context 'when sell by date < 0' do
        let(:items) { [Item.new('foo', -1, 2)] }
        it 'decreases Quality value twice as fast' do
          expect(items[0].quality).to eq 0
        end
      end

      context 'when sell by date < 0' do
        let(:items) { [Item.new('foo', -1, 0)] }
        it 'does not decrease Quality < 0' do
          expect(items[0].quality).to eq 0
        end
      end
    end

    context 'when item is Aged Brie' do
      let(:items) { [Item.new('Aged Brie', 2, 2)] }
      it 'increases Aged Brie Quality' do
        expect(items[0].quality). to eq 3
      end

      context 'when sell by date < 0' do
        let(:items) { [Item.new('Aged Brie', -1, 2)] }
        it 'increases Aged Brie Quality by 2' do
          expect(items[0].quality). to eq 4
        end

        context 'when Quality value is >= 50' do
          let(:items) { [Item.new('Aged Brie', -1, 50)] }
          it 'does not allow Quality > 50' do
            expect(items[0].quality).to eq 50
          end
        end
      end

      context 'when Quality value is >= 50' do
        let(:items) { [Item.new('Aged Brie', 2, 50)] }
        it 'does not allow Quality > 50' do
          expect(items[0].quality).to eq 50
        end
      end
    end

    context 'when item is Backstage passes' do
      let(:items) { [Item.new('Backstage passes to a TAFKAL80ETC concert', 11, 2)] }
      it 'increases Backstage passes Quality' do
        expect(items[0].quality).to eq 3
      end

      context 'when sell by date is 10 days or less' do
        let(:items) { [Item.new('Backstage passes to a TAFKAL80ETC concert', 6, 2)] }
        it 'increases Backstage passes Quality' do
          expect(items[0].quality).to eq 4
        end

        context 'when Quality is 50' do
          let(:items) { [Item.new('Backstage passes to a TAFKAL80ETC concert', 6, 49)] }
          it 'does not increase Quality > 50' do
            expect(items[0].quality).to eq 50
          end
        end
      end

      context 'when sell by date is 5 days or less' do
        let(:items) { [Item.new('Backstage passes to a TAFKAL80ETC concert', 2, 2)] }
        it 'increases Backstage passes Quality' do
          expect(items[0].quality).to eq 5
        end

        context 'when Quality is 50' do
          let(:items) { [Item.new('Backstage passes to a TAFKAL80ETC concert', 2, 49)] }
          it 'does not increase Quality > 50' do
            expect(items[0].quality).to eq 50
          end
        end
      end

      context 'when sell by date is < 0' do
        let(:items) { [Item.new('Backstage passes to a TAFKAL80ETC concert', -1, 2)] }
        it 'decreases Quality to 0' do
          expect(items[0].quality).to eq 0
        end
      end
    end

    context 'when item is Sulfuras' do
      let(:items) { [Item.new('Sulfuras, Hand of Ragnaros', 2, 2)] }
      it 'does not decrease SellIn' do
        expect(items[0].sell_in).to eq 2
      end

      it 'does not decrease Quality' do
        expect(items[0].quality).to eq 2
      end

      context 'when sell by date < 0' do
        let(:items) { [Item.new('Sulfuras, Hand of Ragnaros', -1, 50)] }
        it 'does not decrease Quality' do
          expect(items[0].quality).to eq 50
        end
      end
    end
  end
end
