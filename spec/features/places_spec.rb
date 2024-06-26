require 'rails_helper'

describe "Places" do
  before :each do
    allow(WeatherstackApi).to receive(:current_in).with("kumpula").and_return(
      Weather.new(temperature: 5, weather_icons: ['icon-url'])
    )
  end

  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [Place.new(name: "Oljenkorsi", id: 1)]
    )    

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ 
        Place.new( name:"Oljenkorsi", id: 1 ),
        Place.new( name:"Roskapankki", id: 2 ),
        Place.new( name:"Pikkulintu", id: 3 )  
      ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Roskapankki"
    expect(page).to have_content "Pikkulintu"
  end

  it "if many is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "No locations in kumpula"
  end
end