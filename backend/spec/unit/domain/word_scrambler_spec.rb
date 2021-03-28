# frozen_string_literal: true

require_relative '../../../app/domain/word_scrambler'

RSpec.describe 'Word Scrambler' do
  context 'a two letter word' do
    word = 'it'

    it 'should scramble a word' do
      scrambled = Domain::WordScrambler.scramble(word)

      expect(scrambled).not_to be(word)
    end

    it 'should preserve the length of the original word' do
      scrambled = Domain::WordScrambler.scramble(word)

      expect(scrambled.size).to be(word.size)
    end

    it 'should keep each letter from the original word' do
      scrambled = Domain::WordScrambler.scramble(word)

      scrambled.split('').each do |letter|
        expect(word).to include(letter)
      end
    end
  end

  context 'a three letter word' do
    word = 'the'

    it 'should scramble a word' do
      scrambled = Domain::WordScrambler.scramble(word)

      expect(scrambled).not_to be(word)
    end

    it 'should preserve the length of the original word' do
      scrambled = Domain::WordScrambler.scramble(word)

      expect(scrambled.size).to be(word.size)
    end

    it 'should keep each letter from the original word' do
      scrambled = Domain::WordScrambler.scramble(word)

      scrambled.split('').each do |letter|
        expect(word).to include(letter)
      end
    end
  end

  context 'a word with a typical length' do
    word = 'scramble'

    it 'should scramble a word' do
      scrambled = Domain::WordScrambler.scramble(word)

      expect(scrambled).not_to be(word)
    end

    it 'should preserve the length of the original word' do
      scrambled = Domain::WordScrambler.scramble(word)

      expect(scrambled.size).to be(word.size)
    end

    it 'should keep each letter from the original word' do
      scrambled = Domain::WordScrambler.scramble(word)

      scrambled.split('').each do |letter|
        expect(word).to include(letter)
      end
    end
  end
end
