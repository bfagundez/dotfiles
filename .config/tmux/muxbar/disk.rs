use super::ToModule;
use crate::{
    colors::{Color, Style},
    icons::Icon,
};
use std::{fmt, path::Path, time::Duration};
use sysinfo::Disks;

pub struct DiskFree {
    free: Option<f32>,
    minimum_digits: usize,
    decimal_places: usize,
    disks: Disks,
}

impl DiskFree {
    pub fn new(minimum_digits: usize, decimal_places: usize) -> Self {
        let mut disks = Disks::new_with_refreshed_list();
        let free = read_free(&disks);
        disks.refresh();

        Self {
            free,
            minimum_digits,
            decimal_places,
            disks,
        }
    }
}

fn read_free(disks: &Disks) -> Option<f32> {
    let disk = disks
        .list()
        .iter()
        .find(|disk| disk.mount_point() == Path::new("/"))?;
    let total = disk.total_space();

    (total > 0).then_some((disk.available_space() as f32 / total as f32) * 100.0)
}

impl fmt::Display for DiskFree {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self.free {
            Some(free) => write!(
                f,
                "{:0width$.prec$}%",
                free,
                width = self.minimum_digits,
                prec = self.decimal_places
            ),
            None => write!(f, "N/A"),
        }
    }
}

impl ToModule for DiskFree {
    fn style(&self) -> Style {
        Style::new_with_fg(Color::Green)
    }

    fn icon(&self) -> Option<Icon> {
        Some(Icon::Disk)
    }

    fn update(&mut self) {
        self.disks.refresh();
        self.free = read_free(&self.disks);
    }

    fn next_render_time(&self) -> Option<Duration> {
        Some(Duration::from_secs(15))
    }

    fn include(&self) -> bool {
        self.free.is_some()
    }
}
