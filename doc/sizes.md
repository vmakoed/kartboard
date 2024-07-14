Long names of contestants must be truncated. In the current implementation, the 
max width of name container needs to be restricted. All other surrounding
elements have fixed width and name container's width is calculated by 
subtracting the fixed widths from the total width of the container.

On Desktop, the width of the container is `max-w-md` from Tailwind CSS which
amounts to `28rem`.

This table is a summary of the widths of the elements in the container. Its
purpose is to help calculate the width of the name container whenever the
contestant row needs to be updated.

## Leaderboard page

| Element      | Width             |
|--------------|-------------------|
| Padding      | 1.5rem            |
| Order        | 1.5rem            |
| Gap          | 1rem              |
| Avatar       | 2.5rem            |
| Gap          | 1rem              |
| Gap          | 1rem              |
| Points       | 5rem              |
| Padding      | 1.5 rem           |
| **Total**    | **15rem**         |
| Name (< sm)  | 100vw - 15rem     |
| Name (>= sm) | 13rem             |

## Contest page

| Element      | Width           |
|--------------|-----------------|
| Padding      | 1.5rem          |
| Order        | 1.5rem          |
| Gap          | 1rem            |
| Avatar       | 2.5rem          |
| Gap          | 1rem            |
| Gap          | 1rem            |
| Points       | 5rem            |
| Gap          | 1rem            |
| Position     | 2.5rem          |
| Padding      | 1.5 rem         |
| **Total**    | **18.5rem**     |
| Name (< sm)  | 100vw - 18.5rem |
| Name (>= sm) | 9.5rem          |

## Add player modal

| Element      | Width          |
|--------------|----------------|
| Margin       | 1.5rem         |
| Padding      | 0.75rem        |
| Avatar       | 2rem           |
| Gap          | 0.5rem         |
| Gap          | 0.5rem         |
| Button       | 2rem           |
| Padding      | 0.75 rem       |
| Margin       | 1.5 rem        |
| **Total**    | **9.5rem**     |
| Name (< sm)  | 100vw - 9.5rem |
| Name (>= sm) | 18.5rem        |
