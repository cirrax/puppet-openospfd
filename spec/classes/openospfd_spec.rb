# frozen_string_literal: true

require 'spec_helper'

shared_examples 'openospfd shared examples' do
  it { is_expected.to compile.with_all_deps }
end

describe 'openospfd' do
  on_supported_os.each do |_os, _os_facts|
    context 'with defaults' do
      it_behaves_like 'openospfd shared examples'
    end
  end
end
