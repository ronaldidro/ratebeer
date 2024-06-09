require 'rails_helper'

describe "Beerlist page" do
  before :all do
    # Capybara.register_driver :chrome do |app|
    #   Capybara::Selenium::Driver.new app, browser: :chrome,
    #     options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
    # end
  
    # Capybara.javascript_driver = :chrome
    # WebMock.disable_net_connect!(allow_localhost: true)
    WebMock.allow_net_connect!
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff")
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows the known beers", js:true, :skip => true do
    visit beerlist_path
    expect(page).to have_content "Nikolai"
  end

  it "orders beers by name by default", js: true, :skip => true do
    visit beerlist_path
    beer_table = find('#beertable')
    expect(beer_table.all('.tablerow')[0]).to have_content "Fastenbier"
    expect(beer_table.all('.tablerow')[1]).to have_content "Lechte Weisse"
    expect(beer_table.all('.tablerow')[2]).to have_content "Nikolai"
  end
  
  it "can be ordered by style", js: true, :skip => true do
    visit beerlist_path
    find('#style').click

    beer_table = find('#beertable')
    expect(beer_table.all('.tablerow')[0]).to have_content "Nikolai"
    expect(beer_table.all('.tablerow')[1]).to have_content "Fastenbier"
    expect(beer_table.all('.tablerow')[2]).to have_content "Lechte Weisse"
  end

  it "can be ordered by brewery", js: true, :skip => true do
    visit beerlist_path
    find('#brewery').click

    beer_table = find('#beertable')
    expect(beer_table.all('.tablerow')[0]).to have_content "Lechte Weisse" 
    expect(beer_table.all('.tablerow')[1]).to have_content "Nikolai"
    expect(beer_table.all('.tablerow')[2]).to have_content "Fastenbier"
  end
end