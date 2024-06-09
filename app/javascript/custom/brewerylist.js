const BREWERIES = {};

const handleResponse = (beers) => {
  BREWERIES.list = beers;
  BREWERIES.show();
};

const createTableRow = (brewery) => {
  const tr = document.createElement("tr");
  tr.classList.add("tablerow");

  const breweryname = tr.appendChild(document.createElement("td"));
  breweryname.innerHTML = brewery.name;

  const founded = tr.appendChild(document.createElement("td"));
  founded.innerHTML = brewery.year;

  const beers = tr.appendChild(document.createElement("td"));
  beers.innerHTML = brewery.beers.size;

  const status = tr.appendChild(document.createElement("td"));
  status.innerHTML = brewery.active ? 'Active' : 'Retired';

  return tr;
};

BREWERIES.show = () => {
  document.querySelectorAll(".tablerow").forEach((el) => el.remove());
  const table = document.getElementById("brewerytable");

  BREWERIES.list.forEach((beer) => {
    const tr = createTableRow(beer);
    table.appendChild(tr);
  });
};

BREWERIES.sortByName = () => {
  BREWERIES.list.sort((a, b) => {
    return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
  });
};

BREWERIES.sortByFounded = () => {
  BREWERIES.list.sort((a, b) => {
    return a.year - b.year
  });
};

BREWERIES.sortByBeers = () => {
  BREWERIES.list.sort((a, b) => {
    return a.beers.size - b.beers.size
  });
};

const breweries = () => {
  if (document.querySelectorAll("#brewerytable").length < 1) return;

  document.getElementById("name").addEventListener("click", (e) => {
    e.preventDefault;
    BREWERIES.sortByName();
    BREWERIES.show();
  });

  document.getElementById("founded").addEventListener("click", (e) => {
    e.preventDefault;
    BREWERIES.sortByFounded();
    BREWERIES.show();
  });

  document.getElementById("beers").addEventListener("click", (e) => {
    e.preventDefault;
    BREWERIES.sortByBeers();
    BREWERIES.show();
  });

  fetch("breweries.json")
    .then((response) => response.json())
    .then(handleResponse);
};

export { breweries };