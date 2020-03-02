window.updateIngredientSuggestion = () => {
  var input = document.getElementById("ingredient_name");
  var query = input.value.slice(0, input.selectionEnd);

  $.ajax({
    url: "/ingredients_search_results",
    type: "get",
    data: { query: query },
    success: onSuccessfulSearch,
    error: onFailedSearch
  });
}

var onSuccessfulSearch = (response) => {
  var result = response.results[0];
  var input = document.getElementById("ingredient_name");
  var end = input.selectionEnd;

  if (result) {
    input.value = result.name;
    input.selectionEnd = end;
  } else {
    input.value = input.value.slice(0, end);
  }
}

var onFailedSearch = (response) => {
  console.log(response);
}
