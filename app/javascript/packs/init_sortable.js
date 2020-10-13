import { Sortable, MultiDrag, Swap, OnSpill, AutoScroll } from "sortablejs";

const initSortable = () => {
  const list = document.querySelectorAll('.sortable');
  console.log(list)
  list.forEach( el => {
    Sortable.create(el, {
      group: "localStorage-example",
      store: {
        /**
         * Get the order of elements. Called once during initialization.
         * @param   {Sortable}  sortable
         * @returns {Array}
         */
         get: function (sortable) {
          var order = localStorage.getItem(sortable.options.group.name);
          return order ? order.split("|") : [];
        },

        /**
         * Save the order of elements. Called onEnd (when the item is dropped).
         * @param {Sortable}  sortable
         */
         set: function (sortable) {
          var order = sortable.toArray();
          localStorage.setItem(sortable.options.group.name, order.join("|"));
          console.log(order)
        },
      },
    });
  });
};


export { initSortable };
